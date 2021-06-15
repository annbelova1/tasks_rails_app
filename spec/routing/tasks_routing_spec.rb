require "rails_helper"

RSpec.describe TasksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/tasks").to route_to("tasks#index")
    end

    it "routes to #start" do
      expect(patch: "/tasks/1/start").to route_to("tasks#start", id: "1")
    end

    it "routes to #complete" do
      expect(patch: "/tasks/1/complete").to route_to("tasks#complete", id: "1")
    end

    it "routes to #cancel" do
      expect(patch: "/tasks/1/cancel").to route_to("tasks#cancel", id: "1")
    end

    it "routes to #approve" do
      expect(patch: "/tasks/1/approve").to route_to("tasks#approve", id: "1")
    end

    it "routes to #show" do
      expect(get: "/tasks/1").to route_to("tasks#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/tasks/1/edit").to route_to("tasks#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/tasks").to route_to("tasks#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/tasks/1").to route_to("tasks#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/tasks/1").to route_to("tasks#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/tasks/1").to route_to("tasks#destroy", id: "1")
    end
  end
end
