require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  def setup
    @product = Product.find(1)
  end
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
