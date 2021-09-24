# frozen_string_literal: true

module ActiveAdmin
  module ThumbnailHelper
    def thumbnail_image(model, width = 150)
      if model.image?
        image_tag(model.image(:thumbnail), width: width)
      else
        'No image set'
      end
    end
  end
end
