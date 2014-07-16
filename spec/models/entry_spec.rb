require 'rails_helper'

RSpec.describe Entry, :type => :model do
  let!(:published) { Entry.create entry_word: 'published', word_type: 'noun', translation: 'published', published?: true }
  let!(:unpublished) { Entry.create entry_word: 'unpublished', word_type: 'noun', translation: 'unpublished', published?: false }

  describe :published? do
  	it 'should only return published records' do
  		entries = Entry.published?

      expect(entries).to_not include(unpublished)
      expect(entries).to include(published)
  	end
  end
end
