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
    # binding.pry
    if @end_user.update(end_user_params)
        # マイページで自分の情報を編集した場合は、マイページへ遷移
        # マイページの場合は、transition_flag==1を送っている
        # それ以外は、エンドユーザー一覧に遷移
        if params[:transition_flag]=="1"
          redirect_to mypage_end_users_path
        else
          redirect_to end_users_path
        end
      # パスワードを変更してもログアウトされないようにする
      sign_in(@end_user, bypass: true)
    else
      @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
      render :mypage_edit
    end
  end





  private

  def end_user_params
    params.require(:end_user).permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, :password, :profile_image)
  end

end
