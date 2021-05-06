class ContactFile < ApplicationRecord
  belongs_to :user

  COLUMNS = {
    name: -1,       # Needed from params
    birth: -1,      # Needed from params
    phone: -1,      # Needed from params
    email: -1,      # Needed from params
    card: -1,       # Nedded from params
    card_nums: -1,  # Calculated
    franchise: -1   # Calculated
  }.freeze

  # Expeted: Hash of column names to index of the column:
  # {
  #   "name": 0,
  #   "birth": 3,
  #   "card": 2,
  #   "email": 1
  #   "phone": 4
  # }
  #
  def match_file_columns
    # TODO
  end
end
