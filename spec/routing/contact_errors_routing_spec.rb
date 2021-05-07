require 'rails_helper'

RSpec.describe ContactErrorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/contact_errors').to route_to('contact_errors#index')
    end

    # it "routes to #show" do
    #   expect(get: "/contact_errors/1").to route_to("contact_errors#show", id: "1")
    # end

    # it "routes to #create" do
    #   expect(post: "/contact_errors").to route_to("contact_errors#create")
    # end

    # it "routes to #update via PUT" do
    #   expect(put: "/contact_errors/1").to route_to("contact_errors#update", id: "1")
    # end

    # it "routes to #update via PATCH" do
    #   expect(patch: "/contact_errors/1").to route_to("contact_errors#update", id: "1")
    # end

    # it "routes to #destroy" do
    #   expect(delete: "/contact_errors/1").to route_to("contact_errors#destroy", id: "1")
    # end
  end
end
