class StrongValidator < ActiveModel::EachValidator
  # Regex for checking lowercase, uppercase and digits in the password
  COMPLEXITY_REGEX = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).*$/
  private_constant :COMPLEXITY_REGEX

  # Regex for matching 3 or more repeating chars in a string.
  REPEATING_CHARS_REGEX = /(.)\1{2,}/
  private_constant :REPEATING_CHARS_REGEX

  def validate_each(record, attribute, value)
    return if value.blank?

    if password_length_out_of_bounds?(value)
      record.errors.add(attribute, "must be between 10 and 16 characters")
    end

    if password_has_three_consecutive_chars?(value)
      record.errors.add(attribute, "cannot contain three or more repeating characters in a row.")
    end

    unless password_has_required_char_types?(value)
      record.errors.add(attribute, "must contain at least one lowercase letter, one upper case letter and one digit.")
    end
  end

  private

  def password_length_out_of_bounds?(value)
    value.length < 10 || value.length > 16
  end

  def password_has_three_consecutive_chars?(value)
    value.match?(REPEATING_CHARS_REGEX)
  end

  def password_has_required_char_types?(value)
    value.match?(COMPLEXITY_REGEX)
  end
end
