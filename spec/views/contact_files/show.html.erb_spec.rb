require 'rails_helper'

RSpec.describe "contact_files/show", type: :view do
  before(:each) do
    @contact_file = assign(:contact_file, ContactFile.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
