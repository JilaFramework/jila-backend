class SyncSerializer < ActiveModel::Serializer
  has_many :categories
  has_many :entries

  def categories
    object[:categories]
  end

  def entries
    object[:entries]
  end
end