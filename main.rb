require_relative "lib/basket"
require_relative "lib/product_catalogue"
require_relative "lib/delivery_calculator"
require_relative "lib/offer_calculator"
require_relative "lib/offer"
require "date"

# Initialize the product catalogue with Acme Widget Co products
catalogue = ProductCatalogue.new([
  Product.new("R01", "Red Widget", 32.95),
  Product.new("G01", "Green Widget", 24.95),
  Product.new("B01", "Blue Widget", 7.95),
])

# Initialize delivery calculator with the specified rules
delivery_calculator = DeliveryCalculator.new

# Example: Offer valid for this month only
start_date = Date.today.beginning_of_month rescue Date.new(Date.today.year, Date.today.month, 1)
end_date = Date.today.end_of_month rescue Date.new(Date.today.year, Date.today.month, -1)

# Add multiple offers
offers = [
  Offer.new(
    name: "Buy One Get One 50% Off Red Widget",
    product_code: "R01",
    discount_type: :percentage,
    discount_value: 50,
    min_quantity: 2,
    max_discount: 20.00,
    start_date: start_date,
    end_date: end_date,
  ),
  Offer.new(
    name: "Buy One Get One Free Blue Widget",
    product_code: "B01",
    discount_type: :bogo,
    discount_value: 0, # not used for bogo
    min_quantity: 2,
    max_discount: 15.90,
    start_date: start_date,
    end_date: end_date,
  ),
  Offer.new(
    name: "Red + Green Bundle for $50",
    discount_type: :bundle,
    bundle_codes: ["R01", "G01"],
    discount_value: 50.00,
    max_discount: 10.00,
    start_date: start_date,
    end_date: end_date,
  ),
]

offer_calculator = OfferCalculator.new(offers)

# Create basket with dependency injection
basket = Basket.new(catalogue, delivery_calculator, offer_calculator)

# Test scenarios with new offers
test_scenarios = [
  { products: ["B01", "B01"], description: "Buy One Get One Free on Blue Widget (BOGO)" },
  { products: ["R01", "G01"], description: "Bundle Offer on Red + Green Widget" },
  { products: ["R01", "R01", "R01"], description: "Buy One Get One 50% Off on Red Widget" },
  { products: ["R01", "R01"], description: "Buy One Get One 50% Off on Red Widget" },
  { products: ["B01", "B01", "R01", "R01", "R01"], description: "Multiple offers applied" },
  { products: ["G01", "G01"], description: "No offer applies (just Green Widgets)" },
]

puts "Acme Widget Co - Basket Implementation Test (with Rule-Based Offers)"
puts "=" * 50

test_scenarios.each_with_index do |scenario, index|
  basket.clear
  scenario[:products].each { |code| basket.add(code) }
  actual_total = basket.total
  puts "\nTest #{index + 1}: #{scenario[:description]}"
  puts "Products: #{scenario[:products].join(", ")}"
  puts "Total: $#{actual_total.round(2)}"
end

# Test with no offers at all
offer_calculator = OfferCalculator.new([])
basket = Basket.new(catalogue, delivery_calculator, offer_calculator)
no_offer_products = ["R01", "R01"]
no_offer_total = no_offer_products.each { |code| basket.add(code) }
puts "\nTest #{test_scenarios.size + 1}: No offers applied (Red Widget x2)"
puts "Products: #{no_offer_products.join(", ")}"
puts "Total: $#{basket.total.round(2)}"

puts "\n" + "=" * 50
puts "Test completed!"
