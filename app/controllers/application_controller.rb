class ApplicationController < ActionController::Base
    include Pundit
    protect_from_forgery with: :exception
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_action :prepare_exception_notifier, :get_available_value
  
    helper_method :binary_network_url, :is_defined_param?
  
  
    # include ExceptionLogger::ExceptionLoggable # loades the module   DESCOMENTAR AO INSERIR GEM
    # rescue_from Exception, :with => :log_exception_handler # tells rails to forward the 'Exception' (you can change the type) to the handler of the module    DESCOMENTAR AO INSERIR GEM
  
    def binary_network_url user
      "/network/binary/#{user.id}"
    end
  
    def after_sign_in_path_for(_resource)
      '/blockchain'
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) do |user_params|
          user_params.permit({ roles: [] }, :email, :password, :password_confirmation)
        end
      end
  
    def not_active_user
      '/users/sign_in'
    end
  
    def recreate_binary
      Thread.new{
        users = User.left_joins(:stores).distinct.where("users.id > 135 and (users.plan_id is not null or stores.id is not null) and parent_binary_id is null and users.active = true or stores.active = true")
        # users = User.where("id in (282)")
  
        users.each do |user|
          user.set_binary_recreate(user.key_binary_type_used)
        end
      }
  
      redirect_to '/network/binary/1', notice: 'Rede binaria recriada com sucesso.'
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

    def json_pagination(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.previous_page,
        total_pages: collection.total_pages,
        total_count: collection.total_entries
      }
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
