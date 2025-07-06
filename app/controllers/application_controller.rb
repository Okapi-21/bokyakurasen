class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  add_flash_types :success, :danger
  protect_from_forgery with: :exception

  private

  def not_authenticated
    redirect_to login_path
  end
end
