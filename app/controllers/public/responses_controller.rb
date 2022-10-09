class Public::ResponsesController < ApplicationController
  # 更新機能
  def create

    @tree = Tree.find(params[:tree_id])
    @res = Response.new(response_params)
    #@res.resattachments = params[:response][:resattachments]
    @res.tree_id = @tree.id
    @res.end_user_id = current_end_user.id
     #byebug
    # 修正するをクリック、または@treeがsaveされなかったときはnewに戻る
    if @res.save!
      #@tree.update!(tree_params)
      if tree_params[:is_closed] != @tree.is_closed
        @tree.update(tree_params)
      end
      # コメント通知　adminが投稿したツリーの場合 モデルに定義
      # admin_userが投稿したツリー場合
      if @tree.end_user_id.nil?
        @res.create_admin_ad_notification_res!(current_end_user, @res.id, @tree.id, @tree.post_id, @tree.job_id)
        @res.create_admin_end_notification_res!(current_end_user, @res.id, @tree.id, @tree.post_id)
      # end_userが投稿したツリー場合
      else
        @res.create_end_ad_notification_res!(current_end_user, @res.id, @tree.id, @tree.area_id, @tree.job_id)
        @res.create_end_end_notification_res!(current_end_user, @res.id, @tree.id, @tree.area_id)
      end
      redirect_to tree_path(@tree.id)
    else
      @responses = @tree.responses.page(params[:page])
      render "public/trees/show"
    end
  end

  # 編集
  def edit
    @tree = Tree.find(params[:tree_id])
    @res = current_end_user.responses.find(params[:id])
  end

  # 更新
  def update
    @tree = Tree.find(params[:tree_id])
    @res = current_end_user.responses.find(params[:id])

    # 添付済のファイル削除
    if params[:response][:obj_ids]
      params[:response][:obj_ids].each do |obj_id|
        @resattachment = @res.resattachments.find(obj_id)
        @resattachment.purge
      end
    end

    # 修正するをクリック、または@resがsaveされなかったときはnewに戻る
    if @res.update(response_params)
      if close_params[:tree][:is_closed] != @tree.is_closed
        @tree.update(close_params[:tree])
      end
      redirect_to tree_path(@tree.id)
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @res = current_end_user.responses.find(params[:id])
    @res.delete
    redirect_to tree_path(@res.tree_id)
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