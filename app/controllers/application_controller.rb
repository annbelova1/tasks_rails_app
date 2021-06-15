# frozen_string_literal: true

class ApplicationController < ActionController::Base
    protect_from_forgery prepend: true, with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    def after_sign_in_path_for(_resource)
      tasks_path
    end
  
    def after_sign_out_path_for(_resource_or_scope)
      request.referrer
    end
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :surname, :email, :password) }
      devise_parameter_sanitizer.permit(:account_update) do |u|
        u.permit(:name, :surname, :email, :password, :current_password)
      end
    end
  end
  