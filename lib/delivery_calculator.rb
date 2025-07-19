class DeliveryCalculator
  def initialize(rules = default_rules)
    @rules = rules
  end

  def calculate_delivery_cost(subtotal)
    rule = @rules.find { |rule| subtotal < rule[:threshold] }
    rule ? rule[:cost] : 0
  end

  private

  def default_rules
    [
      { threshold: 50, cost: 4.95 },
      { threshold: 90, cost: 2.95 },
    ]
  end
end
