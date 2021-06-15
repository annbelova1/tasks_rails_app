# frozen_string_literal: true

# Подтвердить таску
module Tasks
  class Approve
    include ServiceObject

    # @param [Task] task задача
    # @param [User] user пользователь, которой подтверждает задачу
    def initialize(task, user)
      @task = task
      @user = user
    end

    def call
      result = validate!
      return result if result.failure?

      task.update(approved_user_ids: task.approved_user_ids << user.id)
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

      unless task.in_progress?
        return handle_error(error("Task in status #{task.status} cannot be approved",
                                  422))
      end
      if already_approve?
        return handle_error(error('
          The task cannot be confirmed twice by the same user',
                                  422))
      end
      return handle_error(error('
        The task cannot be confirmed by creator', 422)) if user.id == task_creator.id

      handle_success('valid')
    end

    def already_approve?
      task.approved_user_ids.include? user.id.to_s
    end

    def task_creator
      @task_creator ||= task.user
    end
  end
end
