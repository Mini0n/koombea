require 'rails_helper'

RSpec.describe 'contact_files/new', type: :view do
  before(:each) do
    assign(:contact_file, ContactFile.new)
  end

  # it "renders new contact_file form" do
  #   render

  #   assert_select "form[action=?][method=?]", contact_files_path, "post" do
  #   end
  # end
end
