require 'rails_helper'

RSpec.describe StrongValidator do
  subject(:model) { model_class.new }

  let(:model_class) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :password

      validates :password, strong: true

      def self.name
        "Temp"
      end
    end
  end

  context 'when password is strong' do
    before { model.password = 'Password123456' }

    it { is_expected.to be_valid }
  end

  context 'when password is less than 10 characters' do
    before { model.password = 'Pass123' }

    specify do
      model.valid?

      expect(model.errors[:password]).to include('must be between 10 and 16 characters')
    end
  end

  context 'when password is greater than 16 characters' do
    before { model.password = 'Password123456789Hello' }

    specify do
      model.valid?

      expect(model.errors[:password]).to include('must be between 10 and 16 characters')
    end
  end

  context 'when password does not contain a digit' do
    before { model.password = 'PasswordHelloWorld' }

    specify do
      model.valid?

      expect(model.errors[:password]).to include('must contain at least one lowercase letter, one upper case letter and one digit.')
    end
  end

  context 'when password does not contain a upper case letter' do
    before { model.password = 'password123456' }

    it { is_expected.not_to be_valid }
  end

  context 'when password does not contain a lower case letter' do
    before { model.password = 'PASSWORD123456' }

    it { is_expected.not_to be_valid }
  end

  context 'when password contains 3 repeating chars' do
    before { model.password = 'Passsword1234' }

    specify do
      model.valid?

      expect(model.errors[:password]).to include('cannot contain three or more repeating characters in a row.')
    end
  end

  context 'when password contains more than 3 repeating chars' do
    before { model.password = 'Passssword1234' }

    it { is_expected.not_to be_valid }
  end
end
