class Profile < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :voivodeship, :country, :city, allow_blank: true, presence: false
end
