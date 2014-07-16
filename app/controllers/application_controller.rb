class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper

  def show_error_messages(obj)
  	error_template = ""
  	obj.errors.full_messages.map do |msg|
  		error_template += "<li>#{msg}</li>"
  	end
  	"<ul>#{error_template}</ul>".html_safe
  end

  def show_flash_error_messages(obj)    
    message = ""
    obj.errors.full_messages.map do |msg|
        message += "#{msg}</br>"
    end
    flash[:danger]= message.html_safe
    
  end

  
  
end
