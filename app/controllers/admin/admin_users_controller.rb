class Admin::AdminUsersController < ApplicationController

  # 管理者一覧
  def index
    @admin_users = AdminUser.all.page(params[:page])
    @areas = Area.where(is_deleted: false, admin_area_flag: false)
    @jobs = Job.where(is_deleted: false)

    # 検索
    if params[:area]
      # your_areaの対象
      # @user = YourArea.where(area_id: params[:area]).pluck(:admin_user_id)
      # @admin_users = AdminUser.where(id: @user)
      # Areaからthorouでyour_areasを通り、admin_userを取得
      @admin_users = Area.find_by(id: params[:area]).admin_users.page(params[:page])
      @bord_name = Area.find(params[:area]).name + " "
      # binding.pry
    elsif params[:job]
      # @user = YourJob.where(job_id: params[:job]).pluck(:admin_user_id)
      # @admin_users = AdminUser.where(id: @user)
      @admin_users = Job.find_by(id: params[:job]).admin_users.page(params[:page])
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
      #一覧画面からと、マイページから飛ぶ場合、リダイレクト先を変更したいので
      # ここで前ページセッションURLを保存(一覧から？マイページから？)
      # request.refererで遷移元のURLを取得することができる
    session[:previous_url] = request.referer
  end





  # 管理者画面編集
  def edit_pass
    @admin_user = AdminUser.find(params[:id])
  end




  # 管理者編集
  def update
    @admin_user = AdminUser.find(params[:id])

    # ◆一覧からの編集、マイページからの編集、パスワードの編集は、全てupdateで行っている。
    # リダイレクトや、render先を、ページによって変更したい
    # update成功時・・・一覧：一覧　マイページから：マイページ　パスワード：マイページ
    # update失敗時・・・一覧：edit マイページ編集：edit パスワード：edit_pass

    # パスワード変更を更新に送る時、transition_flagに3を送って、遷移先を変更
    # 一覧とマイページからの編集は、1つ前のページのアドレス（一覧、マイページ）を保村し、
    # そちらに遷移するようにする

   # パスワード変更の場合
    if params[:transition_flag]=="3"
      # パスワード比較
      if admin_user_params[:password]==params[:admin_user][:password_confirmation]
        # 保存
        if @admin_user.update(admin_user_params)
          redirect_to admin_admin_user_path(@admin_user.id)
          # パスワードを変更してもログアウトされないようにする
          sign_in(@admin_user, bypass: true)
        else
          render :edit_pass
        end
      # パスワードが違ったら
      else
        @admin_user.errors.add(:password, "が違います。" )
        render :edit_pass
      end

    # 登録情報変更か、一覧情報から変更の場合
    else
      if @admin_user.update(admin_user_params)
        # edit時に前のページ（一覧か、マイページ）のURLを、session[:previaous_url]に保存してあるのでそこへリダイレクト
        redirect_to session[:previous_url]
        # パスワードを変更してもログアウトされないようにする
        sign_in(@admin_user, bypass: true)
      else
        @admin_areas = Area.where(admin_area_flag: true).where(is_deleted: false)
        @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
        @jobs = Job.where(is_deleted: false)
        @admin_user.your_areas.build
        @admin_user.your_jobs.build
        render :edit
      end
    end

    # if @admin_user.update(admin_user_params)
    #   # パスワード変更の場合
    #   if params[:transition_flag]=="3"

    #   # 登録情報変更か、一覧情報から変更の場合
    #   else
    #     # edit時に前のページ（一覧か、マイページ）のURLを、session[:previaous_url]に保存してあるのでそこへリダイレクト
    #     redirect_to session[:previous_url]
    #   end
    #   # パスワードを変更してもログアウトされないようにする
    #   sign_in(@admin_user, bypass: true)

    # # 保存が失敗した時
    # else
    #   # パスワード変更時
    #   if params[:transition_flag]=="3"
    #     render :edit_pass

    #   # 一覧かマイページ
    #   else
    #     @admin_areas = Area.where(admin_area_flag: true).where(is_deleted: false)
    #     @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
    #     @jobs = Job.where(is_deleted: false)
    #     @admin_user.your_areas.build
    #     @admin_user.your_jobs.build
    #     render :edit

        # @admin_users = AdminUser.all
        # @areas = Area.where(is_deleted: false, admin_area_flag: false)
        # @jobs = Job.where(is_deleted: false)
        # render :index
      # end

    # end
  end

   # サインアップする時のカラムを増やす
  def admin_user_params
    params.require(:admin_user).permit(:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, :profile_image, :password, area_ids:[], job_ids:[])
  end

end
