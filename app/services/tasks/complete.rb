# frozen_string_literal: true

# Завершить таску
module Tasks
  class Complete
    include ServiceObject

    STAMP_TIME_FORMAT = '%FT%T%:z'

    # @param [Task] task задача
    # @param [User] текущий пользователь
    def initialize(task, user)
      @task = task
      @user = user
    end

    def call
      result = validate!
      return result if result.failure?

      return handle_model_error(task) unless task.valid?

      task.complete!
      task.update(completed_at: Time.current.strftime(STAMP_TIME_FORMAT))

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
        return handle_error(error('Task can be completed only by creator',
                                  422))
      end
      unless task.approved?
        return handle_error(error(
                              'Task should be approved at least two users for being completed', 422
                            ))
      end
      unless task.in_progress?
        return handle_error(error("Task cannot be completed from status #{task.status}",
                                  422))
      end

      handle_success('valid')
    end

    def task_creator
      @task_creator ||= task.user
    end
  end
end
