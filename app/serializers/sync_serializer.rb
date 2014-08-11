class SyncSerializer < ActiveModel::Serializer
  has_many :categories
  has_many :entries
  has_many :image_credits

  def categories
    object[:categories]
  end

  def entries
    object[:entries]
  end

  def image_credits
    object[:image_credits]
  end
end