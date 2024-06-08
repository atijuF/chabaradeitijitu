class Public::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  protected

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end