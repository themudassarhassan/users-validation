class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true

  validates :password, strong: true
end
