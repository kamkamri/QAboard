class Admin::TreesController < ApplicationController

  # 掲示版ツリー一覧
  def index
    @trees = Tree.all
  end

  # 質問入力画面
  def new
    @tree = Tree.new
    @jobs = Job.all
    @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
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
    # !@tree.save !が前にあるので、saveできなかったらになる
    if params[:back] || !@tree.save
      @jobs = Job.all
      @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
      render :new and return
    end
    redirect_to admin_tree_path(@tree.id)
  end

  # 質問詳細画面(レスポンス新規画面)
  def show
    @tree = Tree.find(params[:id])
    @responses = Response.all
    @res = Response.new
  end

  # 質問編集
  def edit
    @tree = Tree.find(params[:id])
    @jobs = Job.all
    @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
  end

  # 質問更新
  def update
    @tree = Tree.find(params[:id])
    if @tree.update(tree_params)
      redirect_to admin_tree_path(@tree.id)
    else
      @jobs = Job.all
      @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
      render :edit
    end
  end

  private
  def tree_params
    params.require(:tree).permit(:post_id, :job_id, :title, :body)
  end

end
