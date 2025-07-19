require "date"

class Offer
  attr_reader :name, :product_code, :discount_type, :discount_value, :max_discount, :start_date, :end_date, :min_quantity, :bundle_codes

  def initialize(name:, discount_type:, discount_value:, start_date: nil, end_date: nil, product_code: nil, bundle_codes: nil, min_quantity: 1, max_discount: nil)
    @name = name
    @discount_type = discount_type.to_sym
    @discount_value = discount_value
    @start_date = start_date ? Date.parse(start_date.to_s) : nil
    @end_date = end_date ? Date.parse(end_date.to_s) : nil
    @product_code = product_code
    @bundle_codes = bundle_codes
    @min_quantity = min_quantity
    @max_discount = max_discount
  end

  def valid_now?(current_date = Date.today)
    after_start = !@start_date || current_date >= @start_date
    before_end = !@end_date || current_date <= @end_date
    after_start && before_end
  end

  def calculate_discount(items)
    return 0 unless valid_now?
    case discount_type
    when :percentage
      apply_percentage_discount(items)
    when :fixed_amount
      apply_fixed_discount(items)
    when :bogo
      apply_bogo_discount(items)
    when :bundle
      apply_bundle_discount(items)
    else
      0
    end
  end

  private

  def apply_percentage_discount(items)
    applicable = items.select { |item| item.code == product_code }
    return 0 if applicable.size < min_quantity
    # For BOGO 50% off, discount applies to every second item
    pairs = applicable.size / 2
    discount = pairs * (applicable.first.price * (discount_value / 100.0))
    max_discount ? [discount, max_discount].min : discount
  end

  def apply_fixed_discount(items)
    applicable = items.select { |item| item.code == product_code }
    return 0 if applicable.size < min_quantity
    discount = discount_value * (applicable.size / min_quantity)
    max_discount ? [discount, max_discount].min : discount
  end

  def apply_bogo_discount(items)
    applicable = items.select { |item| item.code == product_code }
    return 0 if applicable.size < min_quantity
    free_items = applicable.size / min_quantity
    discount = free_items * applicable.first.price
    max_discount ? [discount, max_discount].min : discount
  end

  def apply_bundle_discount(items)
    return 0 unless bundle_codes
    counts = bundle_codes.map { |code| items.count { |item| item.code == code } }
    bundles = counts.min
    return 0 if bundles == 0
    full_price = bundle_codes.sum { |code| items.find { |item| item.code == code }.price }
    discount = bundles * (full_price - discount_value)
    max_discount ? [discount, max_discount].min : discount
  end
end
