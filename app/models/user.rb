# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tasks, class_name: 'Task'

  validates :name, presence: true
    validates :surname, presence: true

    def formatted_name
        "#{self.name} #{self.surname}"
    end
end
