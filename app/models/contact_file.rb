class ContactFile < ApplicationRecord
  has_one_attached :csv_file # Has ONE uploaded file per ContactFile Object

  belongs_to :user

  def run_import
    c_f_s = ContactFileService.new(self)
    c_f_s.call
  end
end
