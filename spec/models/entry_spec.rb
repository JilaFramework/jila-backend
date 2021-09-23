# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry, type: :model do
  before { ApiSweeper.disabled = true }

  after { ApiSweeper.disabled = false }

  let!(:published_tomorrow) do
    described_class.create entry_word: 'published', word_type: 'noun', meaning: 'published', published?: true,
                           updated_at: DateTime.tomorrow
  end
  let!(:unpublished_yesterday) do
    described_class.create entry_word: 'unpublished', word_type: 'noun', meaning: 'unpublished', published?: false,
                           updated_at: DateTime.yesterday
  end

  let!(:first) do
    described_class.create display_order: 1, entry_word: 'C', word_type: 'noun', meaning: 'first', published?: false,
                           updated_at: DateTime.yesterday
  end
  let!(:second) do
    described_class.create display_order: 2, entry_word: 'B', word_type: 'noun', meaning: 'first', published?: false,
                           updated_at: DateTime.yesterday
  end
  let!(:no_order) do
    described_class.create entry_word: 'A', word_type: 'noun', meaning: 'first', published?: false,
                           updated_at: DateTime.yesterday
  end

  describe '#published?' do
    it 'onlies return published records' do
      entries = described_class.published?

      expect(entries).not_to include(unpublished_yesterday)
      expect(entries).to include(published_tomorrow)
    end
  end

  describe '#since' do
    it 'filters entries modified before provided date' do
      entries = described_class.since Time.zone.today.to_s

      expect(entries).not_to include(unpublished_yesterday)
      expect(entries).to include(published_tomorrow)
    end
  end

  describe '#by_display_order' do
    it 'orders entries by display order' do
      entries = described_class.by_display_order

      expect(entries.first).to eq(first)
      expect(entries[1]).to eq(second)
    end
  end

  describe '#alphabetically' do
    it 'returns them sorted by entry word' do
      entries = described_class.alphabetically

      expect(entries.first).to eq(no_order)
      expect(entries[1]).to eq(second)
      expect(entries[2]).to eq(first)
    end
  end
end
