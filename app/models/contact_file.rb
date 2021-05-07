class ContactFile < ApplicationRecord
  has_one_attached :csv_file # Has ONE uploaded file per ContactFile Object

  belongs_to :user
end
