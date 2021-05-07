class ContactFileService
  # COLUMNS = {
  #   name: nil,       # Needed from params
  #   birth: nil,      # Needed from params
  #   phone: nil,      # Needed from params
  #   address: nil,    # Needed from params
  #   email: nil,      # Needed from params
  #   card: nil,       # Nedded from params
  #   card_nums: nil,  # Calculated
  #   franchise: nil   # Calculated
  # }.freeze

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

  NEEDED = %w[address birth card email name phone].freeze
  CALCULATED = %w[card_nums franchise].freeze

  def initialize(contact_file = nil)
    raise ArgumentError, 'Argument needs to be a ContactFile' if contact_file.nil? || contact_file.class != ContactFile

    @contact_file = contact_file
    @errors = {}
  end

  def call
    prepare_columns
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # The Heavy Lifting
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # File
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  def prepase_parsing
    csv_file = @contact_file.csv_file

    return nil unless csv_file.attached?

    csv_file = csv_file.download
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # Columns
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  def prepare_columns
    @matched_columns = match_file_columns
    @errors.merge!(columns: "Bad column matching: #{@contact_file.columns}") if @matched_columns.nil?
    abort_when_error # TODO: This needs to ContactError Handling
  end

  def match_file_columns
    cols = @contact_file.columns
    cols_hash = self.class.valid_json?(cols) ? JSON.parse(cols) : {}

    return nil if cols_hash.empty?
    return nil unless has_needed?(cols_hash)

    result = {}
    NEEDED.each do |column|
      result.merge!(column.to_sym => cols_hash[column])
    end

    result
  end

  def has_needed?(cols_hash)
    return false if cols_hash.keys.count < NEEDED.count

    keys = cols_hash.keys.map(&:downcase).sort

    return keys == NEEDED if keys.count == NEEDED.count

    NEEDED.each do |key|
      return false unless keys.include?(key)
    end

    true
  end

  def self.valid_json?(string)
    !!JSON.parse(string)
  rescue JSON::ParserError
    false
  end

  def abort_when_error
    raise 'Unable to process File' unless @errors.empty?
  end
end
