module ActiveAdmin::ThumbnailHelper
  def thumbnail_image(model, width=250)
    if model.image?
      image_tag(model.image(:thumbnail), width: width)
    else
      'No image set'
    end
  end
end