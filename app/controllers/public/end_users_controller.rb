class Public::EndUsersController < ApplicationController

  # 拠点担当者一覧画面
  def index
    @end_users = EndUser.where(area_id: current_end_user.area_id).where(is_deleted: false)
  end

  def show
  end

  # 拠点担当者編集画面
  def edit
    @end_user = current_end_user
  end

  # 拠点担当者更新
  def update
    @end_user = EndUser.find(params[:id])
    if @end_user.update(end_user_params)
      redirect_to end_users_path
    else
      @end_users = EndUser.where(area_id: current_end_user.area_id).where(is_deleted: false)
      render :index
    end
  end


  private

  def end_user_params
    params.permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted)
  end
end
