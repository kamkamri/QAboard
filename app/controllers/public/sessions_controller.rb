# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :end_user_state, only:[:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource_or_scope)
    trees_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_end_user_session_path
  end


  protected

  # 退会機能確認
  def end_user_state
    #退会しているかを確認するメソッド
    # 処理内容1 入力された社員番号からアカウントを1件取得
    @end_user = EndUser.find_by(employee_number: params[:end_user][:employee_number])
    # アカウントを取得できなかったら、このメソッドを終了
    return if !@end_user
    # 処理内容2 取得したアカウントのパスワードと入力されたパスワードが一致しているかを判別
    # 処理内容3 1と2の処理がTrueだった場合、退会しているか確認
    # 退会している場合・・・退会しているのでTOP画面に遷移し、メッセージを出力
    # 退会していない場合・・・退会していないので、そのままログインする処理
    if @end_user.valid_password?(params[:end_user][:password]) && @end_user.is_deleted == true
      redirect_to root_path, notice: "退会済みです。管理者にご連絡ください。"
    end
  end

end
