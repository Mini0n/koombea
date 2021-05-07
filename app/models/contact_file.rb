class ContactFile < ApplicationRecord
  has_one_attached :csv_file # Has ONE uploaded file per ContactFile Object

  belongs_to :user

  COLUMNS = {
    name: -1,       # Needed from params
    birth: -1,      # Needed from params
    phone: -1,      # Needed from params
    address: -1,    # Needed from params
    email: -1,      # Needed from params
    card: -1,       # Nedded from params
    card_nums: -1,  # Calculated
    franchise: -1   # Calculated
  }.freeze

  # Expeted: Hash of column names to index of the column:
  # {
  # name: 0
  # birth: 1
  # phone: 2
  # address: 3
  # card: 4
  # email: 5
  # }
  #
  def match_file_columns
    # TODO
  end
end
