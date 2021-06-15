# frozen_string_literal: true

# tasks
class Task < ApplicationRecord
  include AASM

  STATUSES = {
    created: 0,
    in_progress: 1,
    completed: 2,
    canceled: 3
  }.freeze

  enum status: STATUSES

  validates :name, presence: true
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  aasm column: 'status', enum: true do
    state :created, initial: true
    state :in_progress, :completed, :canceled

    event :start do
      transitions from: :created, to: :in_progress
    end

    event :cancel do
      transitions from: :in_progress, to: :canceled
    end

    event :complete do
      transitions from: :in_progress, to: :completed
    end
  end

  def approved?
    approvements_count >= 2
  end

  def approved_users_names
    approved_user_ids.map { |id| User.find_by_id(id)&.formatted_name }.join("<br>").html_safe
  end

  def approvements_count
    approved_user_ids.count
  end
end
