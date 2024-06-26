class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_root_path
    else
      user_path(current_user)
    end
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  def application
    @user = User.find(params[:id])
    #@posts = @user.posts.page(params[:page])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email])
  end
end
