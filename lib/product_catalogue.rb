require_relative "product"

class ProductCatalogue
  def initialize(products = [])
    @products = products.to_h { |product| [product.code, product] }
  end

  def add(product)
    @products[product.code] = product
  end

  def find(code)
    @products[code]
  end

  def all
    @products.values
  end

  def empty?
    @products.empty?
  end

  def size
    @products.size
  end
end
