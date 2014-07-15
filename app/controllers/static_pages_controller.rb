class StaticPagesController < ApplicationController
	before_filter :check_user_login

	private

  def check_user_login
    unless signed_in?     	
      redirect_to signin_path
    end
  end
	
end
