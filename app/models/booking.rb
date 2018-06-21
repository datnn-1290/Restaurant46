class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :table
  has_many :booking_details
  has_many :bills
  accepts_nested_attributes_for :booking_details, reject_if: :all_blank

  enum status: {deleted: 0, pending: 1, shipped: 2}
end
