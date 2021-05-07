require "rails_helper"

RSpec.describe ContactFilesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/contact_files").to route_to("contact_files#index")
    end

    it "routes to #new" do
      expect(get: "/contact_files/new").to route_to("contact_files#new")
    end

    it "routes to #show" do
      expect(get: "/contact_files/1").to route_to("contact_files#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/contact_files/1/edit").to route_to("contact_files#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/contact_files").to route_to("contact_files#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/contact_files/1").to route_to("contact_files#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/contact_files/1").to route_to("contact_files#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/contact_files/1").to route_to("contact_files#destroy", id: "1")
    end
  end
end
