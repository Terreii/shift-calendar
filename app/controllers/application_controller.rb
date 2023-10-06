class ApplicationController < ActionController::Base
  def not_found(fallback_path, error_message = t("app.not_found"))
    redirect_to fallback_path, alert: error_message
  end
end
