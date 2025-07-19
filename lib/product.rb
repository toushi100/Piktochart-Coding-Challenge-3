class Product
  attr_reader :code, :name, :price

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end

  def ==(other)
    return false unless other.is_a?(Product)
    @code == other.code && @name == other.name && @price == other.price
  end

  def eql?(other)
    self == other
  end

  def hash
    [@code, @name, @price].hash
  end
end
