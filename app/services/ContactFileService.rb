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
    @imported = 0
    @failed = 0
  end

  def call
    # byebug
    @contact_file.update_attribute(:status, 'Processing')
    prepare_columns
    prepare_importing
    @contact_file.update_attribute(:lines, @csv_file.count)
    start_importing
    @contact_file.update_attribute(:status, set_status(@imported, @failed))
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # The Heavy Lifting
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  def start_importing
    @imported = 0
    @failed = 0
    @csv_file.each_with_index do |row, line_num|
      attrs = row_to_attributes(row)
      unless valid_attributes?(attrs)
        valid_attributes_error(line_num)
        contact_error_report(line_num)
        next
      end

      new_contact = Contact.new({ user: @contact_file.user }.merge(attrs))
      if new_contact.valid?
        new_contact.save
        @imported += 1
      else
        @failed += 1
        @errors.merge!(new_contact.errors.messages)
        contact_error_report(line_num)
      end
    end
  end

  def set_status(imported, failed)
    return 'Finished' if @csv_file.count.zero? || imported.positive?

    return 'Failed' if imported.zero? || failed == @csv_file.count
  end

  def contact_error_report(line_num)
    contact_error = ContactError.new(
      line: @csv_file[line_num],
      line_number: line_num + 1,
      import_errors: @errors,
      attempt: Time.now.to_s,
      user: @contact_file.user,
      contact_file: @contact_file
    )

    contact_error.save

    @errors = {}
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # Attributes Validations
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  def row_to_attributes(row)
    attrs = @columns.each_with_object({}) { |(k, v), h| h.merge!(k => row[v]) }
    card = attrs[:card].to_s
    attrs.merge!(
      {
        card_nums: card[-4..],
        franchise: card.credit_card_brand,
        card: BCrypt::Password.create(card)
      }
    )
  end

  def valid_attributes_error(line_num)
    @errors.merge!(information: "There is invalid information at line #{line_num.to_i + 1}")
  end

  def valid_attributes?(attributes)
    return false if empty_values?(attributes)

    birth = valid_date?(attributes[:birth])

    return false unless birth

    attributes[:birth] = birth

    return false unless valid_name?(attributes[:name]) &&
                        valid_phone?(attributes[:phone]) &&
                        valid_email?(attributes[:email])

    true
  end

  def valid_email?(email)
    !email.to_s.match(URI::MailTo::EMAIL_REGEXP).nil?
  end

  def valid_phone?(phone)
    phone_s = phone.to_s

    format1 = phone_s.match(/(\(\+\d{2}\) \d{3} \d{3} \d{2} \d{2})/)
    format2 = phone_s.match(/(\(\+\d{2}\) \d{3}-\d{3}-\d{2}-\d{2})/)

    !(format1 || format2).nil?
  end

  def valid_date?(date)
    date_s = date.to_s

    format1 = date_s.match(/\d{8}/)
    format2 = date_s.match(/\d{4}-\d{2}-\d{2}/)

    return false if (format1 || format2).nil?

    begin
      if format1
        Date.strptime(date_s, '%Y%m%d')
      else
        Date.strptime(date_s, '%Y-%m-%d')
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
    attributes.values.include?(nil) || attributes.values.include?('')
    # @errors.merge!(columns: 'There are empty values') if res
  end

  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
  # File
  # == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==

  def prepare_importing
    @csv_file = prepare_csv_file
    @errors.merge!(columns: 'Failed reading csv') if @csv_file.nil?
    abort_when_error
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
    abort_when_error
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
    unless @errors.empty?
      contact_error_report(0)
      @contact_file.update_attribute(:status, 'Failed')
      raise 'Unable to process File'
    end
  end
end
