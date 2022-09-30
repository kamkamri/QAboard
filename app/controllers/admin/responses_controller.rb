class Admin::ResponsesController < ApplicationController

  # 更新機能
  def create

    @tree = Tree.find(params[:tree_id])
    @res = Response.new(response_params)
    #@res.resattachments = params[:response][:resattachments]
    @res.tree_id = @tree.id
    @res.admin_user_id = current_admin_user.id
     #byebug
    # 修正するをクリック、または@treeがsaveされなかったときはnewに戻る
    if @res.save!
      #@tree.update!(tree_params)
      if tree_params[:is_closed] != @tree.is_closed
        @tree.update(tree_params)
      end
      # コメント通知　adminが投稿したツリーの場合
      # 対象のツリーをadmin_userが投稿した場合
      if @tree.end_user_id.nil?
        @res.create_admin_notification_res!(current_admin_user, @res.id, @tree.id, @tree.post_id, @tree.job_id)
        @res.create_end_notification_res!(current_admin_user, @res.id, @tree.id, @tree.post_id)
      # 対象のツリーをend_userが投稿した場合
      else
      end
      redirect_to admin_tree_path(@tree.id)
    else
      @tree.responses
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

    # 修正するをクリック、または@resがsaveされなかったときはnewに戻る
    if @res.update(response_params)
      if close_params[:tree][:is_closed] != @tree.is_closed
        @tree.update(close_params[:tree])
      end
      redirect_to admin_tree_path(@tree.id)
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @res = current_admin_user.responses.find(params[:id])
    @res.delete
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
