class Entry < ActiveRecord::Base
	validates :entry_word, :word_type, :meaning, presence: true

  store :extras, accessors: [ :alternate_translations, :alternate_spellings]

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
    order(Arel.sql('display_order IS NULL, display_order ASC'))
  end

  def self.alphabetically
    order(entry_word: :asc)
  end

	def alternate_spellings_raw
    self.alternate_spellings.join("\n") unless self.alternate_spellings.nil?
  end

  def alternate_spellings_raw= values
    self.alternate_spellings = []
    self.alternate_spellings = values.split("\n")
  end

  def alternate_translations_raw
    self.alternate_translations.join("\n") unless self.alternate_translations.nil?
  end

  def alternate_translations_raw= values
    self.alternate_translations = []
    self.alternate_translations = values.split("\n")
  end

  def serialize 
    {
      id: self.id,
      description: self.description,
      entry_word: self.entry_word,
      pronunciation: self.pronunciation,
      word_type: self.word_type,
      meaning: self.meaning,
      example: self.example,
      example_translation: self.example_translation,
      alternate_translations: self.alternate_translations,
      alternate_spellings: self.alternate_spellings,
      audio: self.audio.exists? ? self.audio.url : nil,
      images: {
        thumbnail: self.image? ? self.image(:thumbnail) : nil,
        normal: self.image? ? self.image(:normal) : nil
      },
      categories: self.categories.map(&:id),
    }
  end
end
