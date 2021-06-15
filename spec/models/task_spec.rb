require 'rails_helper'

RSpec.describe Task, type: :model do
  
  describe "creation" do
    let(:task) { FactoryBot.create(:task) }
    it "can be created" do
      expect(task).to be_valid
    end
  end

  describe "validations" do
    let(:task) { FactoryBot.create(:task) }
    it "must have a name" do
      task.name = nil
      expect(task).to_not be_valid
    end   
  end

  describe "user associations" do
    it "can have many tasks" do
      expect(Task.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end  
end
