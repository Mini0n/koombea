require 'rails_helper'

RSpec.describe 'contact_files/index', type: :view do
  before(:each) do
    assign(:contact_files, [
             ContactFile.create!,
             ContactFile.create!
           ])
  end

  # it "renders a list of contact_files" do
  #   render
  # end
end
