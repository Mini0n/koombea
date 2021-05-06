class ImportError < ApplicationRecord
  belongs_to :user
  belongs_to :contact_file
end
