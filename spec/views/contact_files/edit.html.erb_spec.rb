require 'rails_helper'

RSpec.describe 'contact_files/edit', type: :view do
  before(:each) do
    @contact_file = assign(:contact_file, ContactFile.create!)
  end

  # it "renders the edit contact_file form" do
  #   render

  #   assert_select "form[action=?][method=?]", contact_file_path(@contact_file), "post" do
  #   end
  # end
end
