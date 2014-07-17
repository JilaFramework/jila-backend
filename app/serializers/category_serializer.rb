class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :images

  def images 
    {
      thumbnail: object.image(:thumbnail),
      normal: object.image(:normal)
    }
  end
end