# frozen_string_literal: true

class RestAPI < Grape::API
  mount RestAPI::TasksAPI
  mount RestAPI::UsersAPI
end
