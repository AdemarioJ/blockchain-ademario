class ApplicationController < ActionController::Base
    include Pundit
    protect_from_forgery with: :exception
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_action :prepare_exception_notifier, :get_available_value
  
    helper_method :binary_network_url, :is_defined_param?
  
    def after_sign_in_path_for(_resource)
      '/blockchain'
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit({ roles: [] }, :email, :password, :password_confirmation)
      end
    end

    def is_defined_param?(param)
      !params[param].nil? && !params[param].empty?
    end
  
    def string_to_date(date)
      date_f = Date.parse date
      date_f.to_s
    end
    protected
  
    def one_month_days_ago
      Date.today - 30.days
    end
  
    def verify_root_access!
      unless current_user.root?
        redirect_to '/blockchain', notice: 'Você não tem permissão para executar esta ação.'
      end
    end
  
    private
  
    def prepare_exception_notifier
      request.env["exception_notifier.exception_data"] = {
        :USUARIO => current_user.inspect,
        :PARAMS => request.params.inspect
      }
    end
  
    def get_available_value
      @user_balance = current_user.email unless current_user.nil?
    end
  
    def user_not_authorized
      flash[:notice] = 'Você não tem permissão para executar esta ação'
      redirect_to(request.referrer || '/dashboard')
    end
end
