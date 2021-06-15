# frozen_string_literal: true

# Перевести таску в статус in_progress
module Tasks
  class Start
    include ServiceObject

    # @task [task] задача
    # @param [User] user пользователь, которой запускает задачу
    def initialize(task, user)
      @task = task
      @user = user
    end

    def call
      result = validate!
      return result if result.failure?

      task.start!
      return handle_model_error(task) unless task.valid?

      handle_success(task)
    rescue StandardError => e
      Rails.logger.error e

      handle_error(error(e.message, 422))
    end

    private

    attr_reader :task, :user

    def validate!
      return handle_error(error('User was not found', 422)) unless user.present?
      return handle_error(error('Task was not found', 422)) unless task.present?

      unless task_creator.id == user.id
        return handle_error(error("Task can be started only by creator",
                                  422))
      end

      handle_success('valid')
    end

    def task_creator
      @task_creator ||= task.user
    end
  end
end
