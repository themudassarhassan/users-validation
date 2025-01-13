class Users::CSVImportService
  class CSVParsingError < StandardError; end

  Result = Struct.new(:row_data, :status, :message, keyword_init: true)

  def self.call(csv)
    new(csv).execute
  end

  def initialize(csv)
    @csv = csv
  end
  # Declaring it as private to prohibit usage of instance methods.
  private_class_method :new

  def execute
    parse_csv.map { |row| process_row(row) }

  rescue CSV::MalformedCSVError => e
    Rails.logger.error("CSV parsing error: #{e.message}")
    raise CSVParsingError, "Invalid CSV format: #{e.message}"
  end

  private

  def parse_csv
    return [] if @csv.nil?

    CSV.parse(@csv.read, headers: true)
  end

  def process_row(row)
    row_data = build_row_data(row)
    user = User.new(row_data)

    if user.save
      create_success_result(row_data)
    else
      create_failure_result(row_data, user.errors)
    end
  rescue StandardError => e
    Rails.logger.error("Error processing row: #{row.inspect}, Error: #{e.message}")
    create_error_result(row_data, e)
  end

  def build_row_data(row)
    {
      name: row["name"],
      password: row["password"]
    }
  end

  def create_success_result(row_data)
    Result.new(
      row_data: row_data,
      status: :success,
      message: "Successfully created user"
    )
  end

  def create_failure_result(row_data, errors)
    Result.new(
      row_data: row_data,
      status: :failure,
      message: errors.full_messages.to_sentence
    )
  end

  def create_error_result(row_data, error)
    Result.new(
      row_data: row_data,
      status: :error,
      message: "Processing error: #{error.message}"
    )
  end
end
