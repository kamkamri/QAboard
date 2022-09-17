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
      if tree_params[:is_closed] == "true"
        @tree.update(tree_params)
      end
      redirect_to admin_tree_path(@tree.id)
    else
      @responses = Response.all
      render "admin/trees/show"
    end
  end

  def edit
  end

  # ストロングパラメータ
  private
  def response_params
    params.require(:response).permit(:body)
  end

  def tree_params
    params.require(:response).permit(:is_closed)
  end
end
