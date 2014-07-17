class EntrySerializer < ActiveModel::Serializer
  attributes :id, :entry_word, :word_type, :translation, :description, :audio, :images, :categories

  def audio
  	object.audio.url
  end

  def images 
  	{
  		thumbnail: object.image(:thumbnail),
      normal: object.image(:normal)
  	}
  end

  def categories
  	object.categories.map(&:id)
  end
end