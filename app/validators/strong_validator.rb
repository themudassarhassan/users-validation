class StrongValidator < ActiveModel::EachValidator
  # Regex for checking lowercase, uppercase and digits in the password
  COMPLEXITY_REGEX = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).*$/
  private_constant :COMPLEXITY_REGEX

  # Regex for matching 3 or more repeating chars in a string.
  REPEATING_CHARS_REGEX = /(.)\1{2,}/
  private_constant :REPEATING_CHARS_REGEX

  def validate_each(record, attribute, value)
    return if value.blank?

    if value.length < 10 || value.length > 16
      record.errors.add(:password, "must be between 10 and 16 characters")
    end

    if value.match?(REPEATING_CHARS_REGEX)
      record.errors.add(:password, "cannot contain three or more repeating characters in a row.")
    end

    unless value.match?(COMPLEXITY_REGEX)
      record.errors.add(:password, "must contain at least one lowercase letter, one upper case letter and one digit.")
    end
  end
end
