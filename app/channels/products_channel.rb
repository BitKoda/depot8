class ProductsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'store/products'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
