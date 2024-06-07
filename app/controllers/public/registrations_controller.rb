class Public::RegistrationsController < ApplicationController
  def new
    @user = User.new
    resource = @user
    #resourceが未定義になっている、理由不明
  end
  def create
  end
  
end
