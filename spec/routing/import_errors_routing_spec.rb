require "rails_helper"

RSpec.describe ImportErrorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/import_errors").to route_to("import_errors#index")
    end

    it "routes to #show" do
      expect(get: "/import_errors/1").to route_to("import_errors#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/import_errors").to route_to("import_errors#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/import_errors/1").to route_to("import_errors#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/import_errors/1").to route_to("import_errors#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/import_errors/1").to route_to("import_errors#destroy", id: "1")
    end
  end
end
