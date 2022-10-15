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

    # ◆一覧からの編集、マイページからの編集、パスワードの編集は、全てupdateで行っている。
    # リダイレクトや、render先を、ページによって変更するため、:transition_flagで、値を送っている
    #:transition_flag==1. 一覧から削除がクリックされた場合　成功＆失敗　一覧へ
    #:transition_flag==2. マイページ登録情報編集がクリックされた場合　成功：マイページ　失敗: mypage_edit
    #:transition_flag==3. パスワード変更がクリックされた場合　成功:マイページ　失敗:edit_pass

    # パスワード変更を更新に送る時、transition_flagに3を送って、遷移先を変更
    # 一覧とマイページからの編集は、1つ前のページのアドレス（一覧、マイページ）を保村し、
    # そちらに遷移するようにする

    case params[:transition_flag]
    # 一覧画面で、end_user削除の場合
    when "1"
      if @end_user.update(end_user_params)
        redirect_to end_users_path
      else
        @end_users = EndUser.where(area_id: current_end_user.area_id).where(is_deleted: false).page(params[:page])
        render :index
      end

    #マイページで、登録情報変更の場合
    when "2"
      if @end_user.update(end_user_params)
        redirect_to mypage_end_users_path
      else
        @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
        render :mypage_edit
      end

    # マイページで、パスワード変更の場合
    when "3"
      # パスワード比較
      if end_user_params[:password]==params[:end_user][:password_confirmation]
        # 保存
        if @end_user.update(end_user_params)
          redirect_to mypage_end_users_path
          # パスワードを変更してもログアウトされないようにする
          sign_in(@end_user, bypass: true)
        else
          render :edit_pass
        end
      # パスワードが違ったら
      else
        @end_user.errors.add(:password, "が違います。" )
        render :edit_pass
      end

    #どれも違う場合
    else
    end

    # if @end_user.update(end_user_params)
    #     # マイページで自分の情報を編集した場合は、マイページへ遷移
    #     # マイページの場合は、transition_flag==1を送っている
    #     # それ以外は、エンドユーザー一覧に遷移
    #     if params[:transition_flag]=="1"
    #       redirect_to mypage_end_users_path
    #     else
    #       redirect_to end_users_path
    #     end
    #   # パスワードを変更してもログアウトされないようにする
    #   sign_in(@end_user, bypass: true)
    # else
    #   @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
    #   render :mypage_edit
    # end
  end





  private

  def end_user_params
    params.require(:end_user).permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, :password, :profile_image)
  end

end
