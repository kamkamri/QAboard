# frozen_string_literal: true

class Admin::RegistrationsController < Devise::RegistrationsController
  # サインアップする前に、パラムを取り込み可能にする
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @admin_areas = Area.where(admin_area_flag: true).where(is_deleted: false)
    @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
    @jobs = Job.where(is_deleted: false)
    @admin_user = AdminUser.new
    @admin_user.your_areas.build
    @admin_user.your_jobs.build
    super
  end

  # POST /resource
  def create
    @admin_areas = Area.where(admin_area_flag: true).where(is_deleted: false)
    @user_areas=  Area.where(admin_area_flag: false).where(is_deleted: false)
    @jobs = Job.where(is_deleted: false)
    super
  end

  # カスタマイズをするためにクリエイトをコピー
  # def create
  #   build_resource(sign_up_params)

  #   # 追加
  #   @area_ids = params[:your_area][:area_ids]
  #   @job_ids = params[:your_job][:job_ids]
  #   # ぱらむの最初に空白が入っているので、削除する
  #   @area_ids.shift
  #   @job_ids.shift
  #   binding.pry
  #   if resource.save(area_id: 1)
  #     @area_ids.each do |area_id|
  #       your_area = YourArea.new
  #       your_area.admin_user_id = resource.id
  #       your_area.area_id = area_id
  #       your_area.save
  #     end


  #   end

  #   yield resource if block_given?
  #   if resource.persisted?
  #     if resource.active_for_authentication?
  #       set_flash_message! :notice, :signed_up
  #       sign_up(resource_name, resource)
  #       respond_with resource, location: after_sign_up_path_for(resource)
  #     else
  #       set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
  #       expire_data_after_sign_in!
  #       respond_with resource, location: after_inactive_sign_up_path_for(resource)
  #     end
  #   else
  #     clean_up_passwords resource
  #     set_minimum_password_length
  #     respond_with resource
  #   end
  # end




  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end




  protected

  # サインアップする時のカラムを増やす
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:employee_number, :family_name, :first_name, :email, :area_id, :is_deleted, area_ids:[], job_ids:[]])
  end

  # サインアップ後の遷移するページを表示
  def after_sign_up_path_for(resource_or_scope)
    admin_admin_user_path(current_admin_user.id)
  end


end


