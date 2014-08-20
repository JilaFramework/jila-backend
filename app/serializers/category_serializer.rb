class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :images, :games

  def images 
    {
      thumbnail: object.image? ? object.image(:thumbnail) : nil,
      normal: object.image? ? object.image(:normal) : nil
    }
  end

  def games
    {
      image: object.image_game_suitable? && object.image_game_available?,
      audio: object.audio_game_suitable? && object.audio_game_available?
    }
  end
end