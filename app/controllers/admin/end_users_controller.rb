class Admin::EndUsersController < ApplicationController

  # 拠点担当者一覧
  def index
    @end_users = EndUser.all.order(:area_id, area_id: "ASC").page(params[:page])
    @areas = Area.where(is_deleted: false, admin_area_flag: false)
    @jobs = Job.where(is_deleted: false)

    # 検索
    if params[:area]
      # your_areaの対象
      @end_users = EndUser.where(area_id: params[:area]).page(params[:page])
      @bord_name = Area.find(params[:area]).name + " "
    end
  end

  def show
  end

  # 拠点担当者編集
  def edit
    @user_areas = Area.where(admin_area_flag: false).where(is_deleted: false)
    @end_user = EndUser.find(params[:id])
  end

  # 更新機能
  def update
    @end_user = EndUser.find(params[:id])
    if @end_user.update(end_user_params)
      redirect_to admin_end_users_path
    else
      @user_areas = Area.where(admin_area_flag: false).where(is_deleted: false)
      render :edit
    end
  end

   # ストロングパラメータ
  def end_user_params
    params.require(:end_user).permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, :password)
  end


end
