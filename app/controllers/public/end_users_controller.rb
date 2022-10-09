class Public::EndUsersController < ApplicationController

  # 拠点担当者一覧画面
  def index
    @end_users = EndUser.where(area_id: current_end_user.area_id).where(is_deleted: false).page(params[:page])
  end

  def mypage
    @end_user = current_end_user
  end

  # 拠点担当者編集画面
  def mypage_edit
    @end_user = current_end_user
    @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
  end

  # 管理者画面編集
  def edit_pass
    @end_user = current_end_user
  end

  # 拠点担当者更新
  def update
    @end_user = EndUser.find(params[:id])
    if @end_user.update(end_user_params)
      redirect_to end_users_path
      sign_in(@end_user, bypass: true)
    else
      @end_users = EndUser.where(area_id: current_end_user.area_id).where(is_deleted: false)
      render :index
    end
  end


  private

  def end_user_params
    params.require(:end_user).permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, :password, :profile_image)
  end
end
