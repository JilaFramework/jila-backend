class Entry < ActiveRecord::Base
	validates :entry_word, :word_type, :translation, presence: true	

	WORD_TYPES = [
		"noun",
		"verb"
	]
end
