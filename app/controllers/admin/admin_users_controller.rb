class Admin::AdminUsersController < ApplicationController

  # 管理者一覧
  def index
    @admin_users = AdminUser.all
    @areas = Area.where(is_deleted: false, admin_area_flag: false)
    @jobs = Job.where(is_deleted: false)

    # 検索
    if params[:area]
      # your_areaの対象
      @user = YourArea.where(area_id: params[:area]).pluck(:admin_user_id)
      @admin_users = AdminUser.where(id: @user)
      @bord_name = Area.find(params[:area]).name + " "
      # binding.pry
    elsif params[:job]
      @user = YourJob.where(job_id: params[:job]).pluck(:admin_user_id)
      @admin_users = AdminUser.where(id: @user)
      @bord_name = Job.find(params[:job]).name + " "
    else
    end
  end

  # 管理者画面詳細＝マイページ
  def show
    @admin_user = AdminUser.find(current_admin_user.id)
  end

  # 管理者画面編集
  def edit
    @admin_user = AdminUser.find(params[:id])
    @admin_areas = Area.where(admin_area_flag: true).where(is_deleted: false)
    @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
    @jobs = Job.where(is_deleted: false)
    @admin_user.your_areas.build
    @admin_user.your_jobs.build
  end

  # 管理者編集
  def update
    @admin_user = AdminUser.find(params[:id])
    # binding.pry
    # @admin_user.your_areas.build
    # @admin_user.your_jobs.build
    if @admin_user.update(admin_user_params)
      redirect_to admin_admin_users_path
    else
      @admin_users = AdminUser.all
      @areas = Area.where(is_deleted: false, admin_area_flag: false)
      @jobs = Job.where(is_deleted: false)
      render :index
    end
  end

   # サインアップする時のカラムを増やす
  def admin_user_params
    params.require(:admin_user).permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, :profile_image, :password, area_ids:[], job_ids:[])
  end

end
