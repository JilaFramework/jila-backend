require 'rails_helper'

RSpec.describe Entry, :type => :model do
  before { ApiSweeper.disabled = true }
  after { ApiSweeper.disabled = false }

  let!(:published_tomorrow) { Entry.create entry_word: 'published', word_type: 'noun', meaning: 'published', published?: true, updated_at: DateTime.tomorrow }
  let!(:unpublished_yesterday) { Entry.create entry_word: 'unpublished', word_type: 'noun', meaning: 'unpublished', published?: false, updated_at: DateTime.yesterday }

  let!(:first) { Entry.create display_order: 1, entry_word: 'C', word_type: 'noun', meaning: 'first', published?: false, updated_at: DateTime.yesterday }
  let!(:second) { Entry.create display_order: 2, entry_word: 'B', word_type: 'noun', meaning: 'first', published?: false, updated_at: DateTime.yesterday }
  let!(:no_order) { Entry.create entry_word: 'A', word_type: 'noun', meaning: 'first', published?: false, updated_at: DateTime.yesterday }

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

  describe :by_display_order do
    it 'should order entries by display order' do
      entries = Entry.by_display_order

      expect(entries.first).to eq(first)
      expect(entries[1]).to eq(second)
    end
  end

  describe :alphabetically do
    it 'should return them sorted by entry word' do
      entries = Entry.alphabetically

      expect(entries.first).to eq(no_order)
      expect(entries[1]).to eq(second)
      expect(entries[2]).to eq(first)
    end
  end
end