class Entry < ActiveRecord::Base
	validates :entry_word, :word_type, :translation, presence: true	

  store :extras, accessors: [ :alternate_translations ]

  has_one :image_credit, dependent: :destroy
  accepts_nested_attributes_for :image_credit

	has_and_belongs_to_many :categories
	accepts_nested_attributes_for :categories, allow_destroy: false

	WORD_TYPES = [
		"noun",
		"verb",
    "pronoun",
    "adjective",
    "adverb",
    "preposition",
    "conjunction",
    "interjection",
    "phrase"
	]

	has_attached_file :image, styles: {
	  thumbnail: '250x250>',
	  normal: '640x640>',
	  large: '800x800>',
	  xlarge: '1280x1280>'
	}
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  has_attached_file :audio
  validates_attachment_content_type :audio, :content_type => ["audio/mp3", "audio/x-m4a"]

	def self.published?
		where(published?: true)
	end

  def self.since updated_since
    where('updated_at >= ?', updated_since)
  end

  def self.by_display_order
    order('display_order IS NULL, display_order ASC')
  end

  def self.alphabetically
    order(entry_word: :asc)
  end

  def alternate_translations_raw
    self.alternate_translations.join("\n") unless self.alternate_translations.nil?
  end

  def alternate_translations_raw= values
    self.alternate_translations = []
    self.alternate_translations = values.split("\n")
  end
end
