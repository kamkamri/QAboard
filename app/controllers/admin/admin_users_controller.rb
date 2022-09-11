class Admin::AdminUsersController < ApplicationController

  # 管理者一覧
  def index
    @admin_users = AdminUser.all
    @jobs = Job.where(is_deleted: false)
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
    # @admin_user.your_areas.build
    # @admin_user.your_jobs.build
    if @admin_user.update(admin_user_params)
      redirect_to admin_admin_users_path
    else
      @admin_users = AdminUser.all
      render :index
    end
  end

   # サインアップする時のカラムを増やす
  def admin_user_params
    params.require(:admin_user).permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, area_ids:[], job_ids:[])
  end

end
