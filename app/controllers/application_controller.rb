class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  add_flash_types :success, :danger
  protect_from_forgery with: :exception

  private

  def not_authenticated
    redirect_to new_user_session_path
  end

  # ログイン後は問題一覧へ
  def after_sign_in_path_for(resource)
  categories_path
  end
end
