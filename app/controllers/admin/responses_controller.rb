class Admin::ResponsesController < ApplicationController

  # 更新機能
  def create
    @tree = Tree.find(params[:tree_id])
    @res = Response.new(response_params)
    @res.tree_id = @tree.id
    @res.admin_user_id = current_admin_user.id
    # 修正するをクリック、または@treeがsaveされなかったときはnewに戻る
    if @res.save!
      #@tree.update!(tree_params)
      if tree_params[:is_closed] != @tree.is_closed
        @tree.update(tree_params)
      end
      redirect_to admin_tree_path(@tree.id)
    else
      @responses = Response.all
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
    # 修正するをクリック、または@treeがsaveされなかったときはnewに戻る
    if @res.update(response_params)
      if close_params[:tree][:is_closed] != @tree.is_closed
        @tree.update(close_params[:tree])
      end
      redirect_to admin_tree_path(@tree.id)
    else
      @responses = Response.all
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
    params.require(:response).permit(:body)
  end

  def tree_params
    params.require(:response).permit(:is_closed)
  end

  def close_params
    params.require(:response).permit(tree: [:is_closed])
  end
end
