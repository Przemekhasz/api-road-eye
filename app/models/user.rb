class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  has_many :recordings, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?
end
