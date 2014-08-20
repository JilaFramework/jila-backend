module ActiveAdmin::AvailabilityHelper
  def picture_hint(model)
    if model.image_game_suitable?
      ''
    else
      'This category does not have enough entries with pictures for picture games'
    end
  end

  def audio_hint(model)
    if model.audio_game_suitable?
      ''
    else
      'This category does not have enough entries with audio for audio games'
    end
  end
end