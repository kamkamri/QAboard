class Admin::ResponsesController < ApplicationController

  # 更新機能
  def create

    @tree = Tree.find(params[:tree_id])
    @res = Response.new(response_params)
    #@res.resattachments = params[:response][:resattachments]
    @res.tree_id = @tree.id
    @res.admin_user_id = current_admin_user.id
     #byebug
    # レスポンスをsaveできた場合
    if @res.save
      # ツリーのクローズのフラグが保存と違う場合は、ツリーを更新
      # パラメータで出力したbooleanは、文字列になってしまうので、テーブルから出力したものを文字列にして比較
      if tree_params[:is_closed] != @tree.is_closed.to_s
        @tree.update(tree_params)
      # それ以外の場合は、レスが保存された時間で、ツリーの更新日のみを更新
      # 理由は一覧で、ツリー（レスポンスの新規、編集の更新日も含む）で、最新のツリーを上に
      # 持ってくるように並び替えしたいので、ツリーの更新日もレスの保存と同時に更新
      else
        # touchで、更新日updated_atのみ更新できる
        # touch(:created_at)で、引数をつければ、updated_at以外の日付も更新してくれる
        # ただし、バリデーションはしてくれないので、そこだけ注意
        @tree.touch
      end
      # binding.pry
      # コメント通知　adminが投稿したツリーの場合 モデルに定義
      # admin_userが投稿したツリー場合
      if @tree.end_user_id.nil?
        @res.create_admin_ad_notification_res!(current_admin_user, @res.id, @tree.id, @tree.post_id, @tree.job_id)
        @res.create_admin_end_notification_res!(current_admin_user, @res.id, @tree.id, @tree.post_id)
      # end_userが投稿したツリー場合
      else
        @res.create_end_ad_notification_res!(current_admin_user, @res.id, @tree.id, @tree.area_id, @tree.job_id)
        @res.create_end_end_notification_res!(current_admin_user, @res.id, @tree.id, @tree.area_id)
      end
      redirect_to admin_tree_path(@tree.id)
    else
      @areas = Area.where(admin_area_flag: false).where(is_deleted: false)
      @jobs = Job.where(is_deleted: false)
      @admin_user = current_admin_user
      @responses = @tree.responses.page(params[:page])
      render "admin/trees/show"
    end
  end





  # 編集
  def edit
    @tree = Tree.find(params[:tree_id])
    @res = current_admin_user.responses.find(params[:id])
  end





  # 更新
  def update
    @tree = Tree.find(params[:tree_id])
    @res = current_admin_user.responses.find(params[:id])

    # 添付済のファイル削除
    if params[:response][:obj_ids]
      params[:response][:obj_ids].each do |obj_id|
        @resattachment = @res.resattachments.find(obj_id)
        @resattachment.purge
      end
    end

    # @resをupdate
    if @res.update(response_params)
      # binding.pry
      # 保存しているクローズフラグと、送られてきたフラグが違う場合
      # パラメータで出力したbooleanは、文字列になってしまうので、テーブルから出力したものを文字列にして比較
      if close_params[:tree][:is_closed] != @tree.is_closed.to_s
        @tree.update(close_params[:tree])
      # それ以外の場合は、レスが保存された時間で、ツリーの更新日のみを更新
      # 理由は一覧で、ツリー（レスポンスの新規、編集の更新日も含む）で、最新のツリーを上に
      # 持ってくるように並び替えしたいので、ツリーの更新日もレスの保存と同時に更新
      else
        # touchで、更新日updated_atのみ更新できる
        # touch(:created_at)で、引数をつければ、updated_at以外の日付も更新してくれる
        # ただし、バリデーションはしてくれないので、そこだけ注意
        @tree.touch
      end
      redirect_to admin_tree_path(@tree.id)
    else
      render :edit
    end
  end






  # 削除
  def destroy
    @res = current_admin_user.responses.find(params[:id])

    # @res.delete
    # 関連データを一緒に削除したいのでdestroyに変更
    @res.destroy
    redirect_to admin_tree_path(@res.tree_id)
  end

  # ストロングパラメータ
  private
  def response_params
    params.require(:response).permit(:body, resattachments: [])
  end

  def tree_params
    params.require(:response).permit(:is_closed)
  end

  def close_params
    params.require(:response).permit(tree: [:is_closed])
  end
end
