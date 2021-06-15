# frozen_string_literal: true

class RestAPI
class TasksAPI < Grape::API
  include Devise::Controllers::Helpers
  format :json
  # prefix :api

  helpers do
    def warden
      env['warden']
    end

    def authenticated
      if warden.authenticated?
        true
      elsif params[:access_token] &&
            User.find_for_token_authentication('access_token' => params[:access_token])
        true
      elsif params[:xapp_token] &&
            AccessGrant.find_access(params[:xapp_token])
        true
      else
        error!('401 Unauthorized', 401)
      end
    end

    def current_user
      warden.user || User.find_for_token_authentication('access_token' => params[:access_token])
    end

    def authenticated_user
      authenticated
      error!('401 Unauthorized', 401) unless current_user
    end

    def task
      @task ||= Task.find(params[:id])
    end
  end

  resource :tasks do
    desc 'Return all tasks.'
    get do
      @tasks = Task.all
    end

    desc 'Start a task'
    route_param :id do
      patch :start do
        authenticated_user
        Tasks::Start.call(task, current_user)
      end
    end

    desc 'Approve a task'
    route_param :id do
      patch :approve do
        authenticated_user
        Tasks::Approve.call(task, current_user)
      end
    end

    desc 'Cancel a task'
    route_param :id do
      patch :cancel do
        authenticated_user
        Tasks::Cancel.call(task, current_user)
      end
    end

    desc 'Complete a task'
    route_param :id do
      patch :complete do
        authenticated_user
        Tasks::Complete.call(task, current_user)
      end
    end

    desc 'Create a task'
    params do
      requires :name, type: String
    end
    post do
      authenticated_user
      Task.create!({
                     user: current_user,
                     name: params[:name]
                   })
    end
  end
end
end