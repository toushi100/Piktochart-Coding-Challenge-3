require "date"
require_relative "offer"

class OfferCalculator
  def initialize(offers = [])
    @offers = offers
  end

  def calculate_discount(items, current_date = Date.today)
    @offers.select { |offer| offer.valid_now?(current_date) }
           .sum { |offer| offer.calculate_discount(items) }
  end

  def add_offer(offer)
    @offers << offer
  end

  def remove_offer(offer)
    @offers.delete(offer)
  end
end
