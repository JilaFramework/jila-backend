# frozen_string_literal: true

module ActiveAdmin
  module AudioHelper
    def audio_link(model)
      if model.audio?
        link_to 'Listen', model.audio.url, target: 'window'
      else
        'No audio set'
      end
    end
  end
end
