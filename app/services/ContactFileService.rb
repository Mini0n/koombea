require 'csv'
require 'credit_card_validations/string'
require 'bcrypt'

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
    @contact_file.update_attribute(:status, 'Processing')
    prepare_columns
    prepare_importing
    @contact_file.update_attribute(:lines, @csv_file.count)
    start_importing
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # The Heavy Lifting
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  def start_importing
    @csv_file.each do |row|
      attrs = row_to_attributes(row)
      # byebug
      puts '- ' * 20
      ap attrs
      valid_attributes?(attrs)
    end

    puts '--- DONE'
  end

  def row_to_attributes(row)
    attrs = @columns.each_with_object({}) { |(k, v), h| h.merge!(k => row[v]) }
    card = attrs[:card].to_s
    attrs.merge!(
      {
        card_nums: card[-4..-1],
        franchise: card.credit_card_brand,
        card: BCrypt::Password.create(card)
      }
    )
  end

  def valid_attributes?(attributes)
    return false if empty_values?(attributes)

    return false unless valid_name?(attributes[:name])

    byebug

    return false unless valid_date?(attributes[:birth])

    byebug
  end

  def valid_date?(date)
    format1 = date.to_s.match(/\d{8}/)
    format2 = date.to_s.match(/\d{4}-\d{2}-\d{2}/)

    return false if (format1 || format2).nil?

    parsed = begin
      if format1
        Date.strptime(date.to_s, '%Y%m%d')
      else
        Date.strptime(date.to_s, '%Y-%m-%d')
      end
    rescue StandardError
      false
    end
  end

  # Alphanumer & Hyphen ("-") are allowed
  def valid_name?(name)
    name.to_s.index(/[^[:alnum:]-]/).nil?
  end

  def empty_values?(attributes)
    res = attributes.values.include?(nil) || attributes.values.include?('')
    @errors.merge!(columns: 'There are empty values') if res
    res
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # File
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  def prepare_importing
    @csv_file = prepare_csv_file
    @errors.merge!(columns: 'Failed reading csv') if @csv_file.nil?
    abort_when_error # TODO: This needs to ContactError Handling
  end

  def prepare_csv_file
    return nil unless @contact_file.csv_file.attached?

    CSV.parse(@contact_file.csv_file.download)
  rescue StandardError
    nil
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # Columns
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  def prepare_columns
    @columns = match_file_columns
    @errors.merge!(columns: "Bad column matching: #{@contact_file.columns}") if @columns.nil?
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
