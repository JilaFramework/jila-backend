require 'rails_helper'

RSpec.describe Entry, :type => :model do
  let!(:published_tomorrow) { Entry.create entry_word: 'published', word_type: 'noun', translation: 'published', published?: true, updated_at: DateTime.tomorrow }
  let!(:unpublished_yesterday) { Entry.create entry_word: 'unpublished', word_type: 'noun', translation: 'unpublished', published?: false, updated_at: DateTime.yesterday }

  describe :published? do
  	it 'should only return published records' do
  		entries = Entry.published?

      expect(entries).to_not include(unpublished_yesterday)
      expect(entries).to include(published_tomorrow)
  	end
  end

  describe :since do
    it 'should filter entries modified before provided date' do
      entries = Entry.since Date.today.to_s

      expect(entries).to_not include(unpublished_yesterday)
      expect(entries).to include(published_tomorrow)
    end
  end
end
