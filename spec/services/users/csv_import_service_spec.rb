require 'rails_helper'

RSpec.describe Users::CSVImportService do
  subject(:call) do
    described_class.call(csv_file)
  end
  let(:csv_content) { "name,password\nJohn Doe,Password123\nJane Doe,Password456" }
  let(:csv_file) { StringIO.new(csv_content) }
  let(:results) { call }

  context 'when csv has proper user data' do
    specify do
      expect(results.size).to eq(2)
    end

    specify do
      expect(results.map(&:status)).to match_array([ :success, :success ])
    end

    specify do
      expect(results.map(&:row_data)).to match_array([
        { name: 'John Doe', password: 'Password123' },
        { name: 'Jane Doe', password: 'Password456' }
      ])
    end

    specify do
      expect(results.map(&:message)).to match_array([
        'Successfully created user',
        'Successfully created user'
      ])
    end
  end

  context 'when csv has users with either empty name or weak password' do
    let(:csv_content) do
      "name,password\nJohn Doe,Password123Helloworld\nJane Doe,password123\n,Password123\nDavid,Passsword123"
    end

    specify do
      expect(results.map(&:status)).to match_array([ :failure, :failure, :failure, :failure ])
    end

    specify do
      expect(results.map(&:message)).to match_array([
        "Name can't be blank",
        'Password must be between 10 and 16 characters',
        'Password must contain at least one lowercase letter, one upper case letter and one digit.',
        'Password cannot contain three or more repeating characters in a row.'
      ])
    end
  end

  context 'when no csv file is provided' do
    let(:csv_file) { nil }

    specify do
      expect(results).to be_empty
    end
  end

  context 'with invalid csv format' do
    let(:csv_content) { "name,password\n\"John\" Doe, pass,word" }

    specify do
      expect { results }.to raise_error(Users::CSVImportService::CSVParsingError)
    end
  end
end
