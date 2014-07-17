class Entry < ActiveRecord::Base
	validates :entry_word, :word_type, :translation, presence: true	

	has_and_belongs_to_many :categories
	accepts_nested_attributes_for :categories, allow_destroy: false

	WORD_TYPES = [
		"noun",
		"verb"
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
end
