class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  def applicaton
    @user = User.find(params[:id])
    #@posts = @user.posts.page(params[:page])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email])
  end
end
