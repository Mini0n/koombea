class Contact < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :email, scope: :user_id
end
