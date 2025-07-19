# Acme Widget Co – Basket System

A clean, extensible Ruby implementation of a shopping basket for Acme Widget Co, demonstrating best practices in object-oriented design, separation of concerns, and rule-based offers.

---

## Features

- **Simple Basket API**: `add` and `total` methods for easy integration
- **Flexible Product Catalogue**: Add, remove, and look up products efficiently
- **Configurable Delivery Rules**: Delivery cost based on order value
- **Extensible Offer System**: Add/remove offers easily using the Strategy pattern
- **Dependency Injection**: All dependencies are injected for testability and flexibility

---

## Getting Started

```ruby
# Initialize catalogue
catalogue = ProductCatalogue.new([
  Product.new('R01', 'Red Widget', 32.95),
  Product.new('G01', 'Green Widget', 24.95),
  Product.new('B01', 'Blue Widget', 7.95)
])

delivery_calculator = DeliveryCalculator.new
offer_calculator = OfferCalculator.new([
  BuyOneGetOneHalfPrice.new('R01')
])

basket = Basket.new(catalogue, delivery_calculator, offer_calculator)

basket.add('R01')
basket.add('G01')

puts basket.total # => e.g. $60.85
```

---

## Delivery Rules

- **< $50**: $4.95
- **$50–$89.99**: $2.95
- **$90+**: Free

---

## Special Offers

- **Buy One Red Widget, Get Second Half Price**: For every two R01s, the second is half price.

---

## Architecture & Design Patterns

- **Basket**: Main interface for adding products and calculating totals
- **Product & ProductCatalogue**: Product data and fast lookup
- **DeliveryCalculator**: Configurable delivery cost logic
- **OfferCalculator**: Manages multiple offers (Strategy pattern)
- **Strategy Pattern**: For both delivery and offer rules
- **Dependency Injection**: For all major components
- **Open/Closed Principle**: Easily extend with new offers or rules

---

## Extending the System

**Add a Product:**
```ruby
catalogue.add(Product.new('Y01', 'Yellow Widget', 15.95))
```

**Add a Delivery Rule:**
```ruby
custom_rules = [
  { threshold: 25, cost: 6.95 },
  { threshold: 75, cost: 3.95 }
]
delivery_calculator = DeliveryCalculator.new(custom_rules)
```

**Add a New Offer:**
```ruby
new_offer = offer.new({
      name: "Red + Green Bundle for $50",
    discount_type: :percent,
    bundle_codes: ["R01", "G01"],
    discount_value: 50.00,
    max_discount: 10.00,
    start_date: start_date,
    end_date: end_date,
}
)
```

---

## Running Example Scenarios

Run all example scenarios:
```bash
ruby main.rb
```

Expected outputs:
1. B01, G01 → $37.85
2. R01, R01 → $54.37
3. R01, G01 → $60.85
4. B01, B01, R01, R01, R01 → $98.27

---

## Assumptions

- Product codes are unique strings
- Prices are floats (dollars and cents)
- Multiple offers can be active at once
- Delivery is calculated after discounts
- Standard Ruby float arithmetic (consider BigDecimal for production)

---

## Future Improvements

- Use BigDecimal for monetary values
- Add Different User Types
- Validate product codes/prices
- Logging and monitoring
