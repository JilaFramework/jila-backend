require 'rails_helper'

RSpec.describe Category, :type => :model do
  before { ApiSweeper.disabled = true }
  after { ApiSweeper.disabled = false }

  describe 'scopes' do
    let!(:tomorrow) { Category.create name: 'tomorrow', position: 2, updated_at: Date.tomorrow }
    let!(:yesterday) { Category.create name: 'yesterday', position: 1, updated_at: Date.yesterday }
    let!(:published) { Entry.create entry_word: 'published', word_type: 'noun', meaning: 'published', published?: true, categories: [yesterday]}
    let!(:unpublished) { Entry.create entry_word: 'unpublished', word_type: 'noun', meaning: 'unpublished', published?: false, categories: [tomorrow]}

    describe :since do
      it 'should filter categories modified before provided date' do
        categories = Category.since Date.today.to_s

        expect(categories).to_not include(yesterday)
        expect(categories).to include(tomorrow)
      end
    end

    describe :with_published_entries do
      it 'should filter categories with no published entries' do
        categories = Category.with_published_entries

        expect(categories).to include(yesterday)
        expect(categories).to_not include(tomorrow)
      end
    end

    describe :by_display_order do
      it 'should order entries by position (display order)' do
        categories = Category.by_display_order

        expect(categories.first).to eq(yesterday)
        expect(categories[1]).to eq(tomorrow)
      end
    end
  end

  describe :image_game_suitable? do
    let!(:category) { Category.create name: 'testCategory' }
    let!(:entry1) { Entry.create entry_word: 'one', word_type: 'noun', meaning: '1', image_file_name: 'image1.png', categories: [category] }
    let!(:entry2) { Entry.create entry_word: 'two', word_type: 'noun', meaning: '2', image_file_name: 'image2.png', categories: [category] }
    let!(:entry3) { Entry.create entry_word: 'three', word_type: 'noun', meaning: '3', image_file_name: 'image3.png', categories: [category] }
    let!(:entry_no_image) { Entry.create entry_word: 'noimage', word_type: 'noun', meaning: 'noimage', image_file_name: nil, categories: [category] }

    context 'when 4 or more entries have images' do
      let!(:entry4) { Entry.create entry_word: 'four', word_type: 'noun', meaning: '4', image_file_name: 'image4.png', categories: [category] }

      it 'should be true' do
        expect(category.image_game_suitable?).to be(true)
      end
    end

    context 'when less than 4 entries have images' do
      it 'should be false' do
        expect(category.image_game_suitable?).to be(false)
      end
    end
  end

  describe :audio_game_suitable? do
    let!(:category) { Category.create name: 'testCategory' }
    let!(:entry1) { Entry.create entry_word: 'one', word_type: 'noun', meaning: '1', audio_file_name: 'audio1.png', categories: [category] }
    let!(:entry_no_audio) { Entry.create entry_word: 'noaudio', word_type: 'noun', meaning: 'noaudio', audio_file_name: nil, categories: [category] }

    context 'when 2 or more entries have audio' do
      let!(:entry2) { Entry.create entry_word: 'two', word_type: 'noun', meaning: '2', audio_file_name: 'audio2.png', categories: [category] }

      it 'should be true' do
        expect(category.audio_game_suitable?).to be(true)
      end
    end

    context 'when less than 2 entries have images' do
      it 'should be false' do
        expect(category.audio_game_suitable?).to be(false)
      end
    end
  end
end
