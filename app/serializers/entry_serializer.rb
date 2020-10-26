class EntrySerializer < ActiveModel::Serializer
<<<<<<< HEAD
  attributes :id, :entry_word, :pronunciation, :word_type, :meaning, :example, :example_translation, :alternate_translations, :alternate_spellings, :description, :audio, :images, :categories
=======
  attributes :id, :entry_word, :pronunciation, :word_type, :translation, :meaning, :example, :example_translation, :alternate_translations, :alternate_spellings, :description, :audio, :images, :categories
>>>>>>> 5582310e8d5ff93e98b18a85af94cccfba6fe128

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
