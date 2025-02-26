class Product < ApplicationRecord
  has_one_attached :image
  after_commit -> { broadcast_refresh_later_to "products" }

  validates :title, :description, :image, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validate :acceptable_image

  def acceptable_image
    return unless image.attached?

    acceptable_types = ['image/gif', 'image/jpeg', 'image/png']
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be GIF, JP(E)G or PNG")
    end
  end
end
