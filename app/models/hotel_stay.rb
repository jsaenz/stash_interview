class HotelStay < ActiveRecord::Base

  attr_accessible :checkout_at, :hotel_id, :member_id
  attr_accessor :finalscore

  belongs_to :hotel
  belongs_to :member

  validates :hotel, presence: true
  validates :member, presence: true
  validates :checkout_at, inclusion: { in: (Date.civil(2010, 5, 19))..(Date.today) }

end
