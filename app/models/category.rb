# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true

  has_one :image_credit, dependent: :destroy
  accepts_nested_attributes_for :image_credit

  has_and_belongs_to_many :entries
  acts_as_list

  has_attached_file :image, styles: {
    thumbnail: '250x250>',
    normal: '640x640>',
    large: '800x800>',
    xlarge: '1280x1280>'
  }
  validates_attachment_content_type :image, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  def self.since(updated_since)
    where("categories.updated_at >= ?", updated_since)
  end

  def self.with_published_entries
    joins(:entries).where(entries: { published?: true }).distinct
  end

  def self.by_display_order
    order(Arel.sql('position ASC'))
  end

  def image_game_suitable?
    entries.where.not(image_file_name: nil).count > 3
  end

  def audio_game_suitable?
    entries.where.not(audio_file_name: nil).count > 1
  end

  def serialize
    {
      id: id,
      name: name,
      images: {
        thumbnail: image? ? image(:thumbnail) : nil,
        normal: image? ? image(:normal) : nil
      },
      games: {
        image: image_game_suitable? && image_game_available?,
        audio: audio_game_suitable? && audio_game_available?
      }
    }
  end
end
