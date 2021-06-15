# frozen_string_literal: true

class ServiceResultObject
  attr_reader :data

  def initialize(success = true, data = {})
    @success = success
    @data = data
  end

  def success?
    @success == true
  end

  def failure?
    !success?
  end

  def message
    return '' if success?

    data[:errors].first.fetch(:title, '')
  end

  def backtrace
    []
  end

  def log
    success? ? Rails.logger.info(data) : Rails.logger.error(data)
  end
end
