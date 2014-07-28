class EntrySerializer < ActiveModel::Serializer
  attributes :id, :entry_word, :word_type, :translation, :alternate_translations, :description, :audio, :images, :categories

  def audio
  	object.audio.url if object.audio.exists?
  end

  def images 
  	{
  		thumbnail: object.image? ? object.image(:thumbnail) : nil,
      normal: object.image? ? object.image(:normal) : nil
  	}
  end

  def categories
  	object.categories.map(&:id)
  end
end