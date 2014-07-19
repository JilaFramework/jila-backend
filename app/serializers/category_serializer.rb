class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :images

  def images 
    {
      thumbnail: object.image? ? object.image(:thumbnail) : nil,
      normal: object.image? ? object.image(:normal) : nil
    }
  end
end