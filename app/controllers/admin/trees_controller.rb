class Admin::TreesController < ApplicationController

  # 掲示版ツリー一覧
  def index
    @trees = Tree.all
  end

  # 質問入力画面
  def new
    @tree = Tree.new
    @jobs = Job.all
  end

  # 質問確認画面
  def confirm
    @tree = Tree.new(tree_params)
  end

  # 更新機能
  def create
    @tree = Tree.new(tree_params)
    @tree.admin_user_id = current_admin_user.id
    @tree.area_id = current_admin_user.area_id
    # 修正するをクリック、または@treeがsaveされなかったときはnewに戻る
    if params[:back] || !@tree.save
      @jobs = Job.all
      render :new and return
    end
    redirect_to admin_tree_path(@tree.id)
  end

  def show
  end

  def edit
  end

  private
  def tree_params
    params.require(:tree).permit(:job_id, :title, :body)
  end

end
