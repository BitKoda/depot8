require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products 

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(
      title: "My Book Title",
      description: "yyy"
    )
    product.image.attach(
      io: File.open("test/fixtures/files/lorem.jpg"), 
      filename: "lorem.jpg", 
      content_type: "image/jpeg"
    )
    product.price = -1
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01" ],
    product.errors[:price]
    
    product.price = 0
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01" ],
    product.errors[:price]
    
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(
      title: "My Book Title",
      description: "yyy",
      price: 1
    )
    
    product.image.attach(
      io: File.open("test/fixtures/files/lorem.jpg"), 
      filename: "lorem.jpg", 
      content_type: "image/jpeg"
    )
  end

  test "image url" do 
    product = Product.new(
      title: "My Book Title",
      description: "yyy",
      price: 1 
    )
    product.image.attach(
      io: File.open("test/fixtures/files/lorem.jpg"), 
      filename: "lorem.jpg", 
      content_type: "image/jpeg"
    )
    assert product.valid?, "image/jpeg must be valid"
    
    product = Product.new(
      title: "My Book Title",
      description: "yyy",
      price: 1 
    )
    product.image.attach(
      io: File.open("test/fixtures/files/logo.svg"), 
      filename: "logo.svg", 
      content_type: "image/svg+xml"
    )
    assert_not product.valid?, "image/svg+xml must be invalid"
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:pragprog).title,
                          description: "yyy",
                          price:1
                         )
    product.image.attach(
      io: File.open("test/fixtures/files/lorem.jpg"), 
      filename: "lorem.jpg", 
      content_type: "image/jpeg"
    )
    assert product.invalid?
    assert_equal [ "has already been taken" ], product.errors[:title]
  end
end
