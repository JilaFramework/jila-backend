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
end
