# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::SyncController, type: :controller do
  let(:category1) { Category.new id: 37, name: 'Family' }
  let(:category2) { Category.new id: 24, name: 'Body Parts' }
  let(:entry) do
    Entry.new id: 3, entry_word: 'Mimi',
              word_type: 'noun',
              meaning: 'Grandma',
              alternate_translations: ['Granny'],
              alternate_spellings: ['Mummy'],
              description: 'Mum\'s mum',
              categories: [category1, category2]
  end

  before(:all) do
    ApiSweeper.disabled = true
  end

  before do
    allow(entry).to receive_message_chain(:audio, :exists?).and_return(true)
    allow(entry).to receive_message_chain(:audio, :url).and_return('s3.m4a')
    allow(entry).to receive(:image?).and_return(true)
    allow(entry).to receive(:image).with(:thumbnail).and_return('thumb.png')
    allow(entry).to receive(:image).with(:normal).and_return('normal.png')
    allow(category1).to receive(:image?).and_return(true)
    allow(category1).to receive(:image).with(:thumbnail).and_return('cat_thumb1.png')
    allow(category1).to receive(:image).with(:normal).and_return('cat_normal1.png')
  end

  describe 'GET #entries' do
    before do
      allow(Entry).to receive(:by_display_order).and_return(Entry)
      allow(Entry).to receive(:alphabetically).and_return(Entry)
      allow(Entry).to receive(:published?).and_return([entry])
    end

    context 'with no date provided' do
      it 'returns all published entries in JSON' do
        allow(Entry).to receive(:since)

        get :entries

        parsed_response = JSON.parse response.body

        expect(parsed_response['entries'].length).to eq(1)

        first_entry = parsed_response['entries'].first
        expect(first_entry['id']).to eq(3)
        expect(first_entry['entry_word']).to eq('Mimi')
        expect(first_entry['word_type']).to eq('noun')
        expect(first_entry['meaning']).to eq('Grandma')
        expect(first_entry['alternate_translations']).to eq(['Granny'])
        expect(first_entry['alternate_spellings']).to eq(['Mummy'])
        expect(first_entry['description']).to eq('Mum\'s mum')
        expect(first_entry['audio']).to eq('s3.m4a')
        expect(first_entry['images']['thumbnail']).to eq('thumb.png')
        expect(first_entry['images']['normal']).to eq('normal.png')
        expect(first_entry['categories']).to eq([37, 24])

        expect(Entry).not_to have_received(:since)
      end
    end

    context 'with a date provided' do
      it 'returns all published entries modified after the provided date' do
        allow(Entry).to receive(:since).with(DateTime.parse('2010-06-01'))
                                       .and_return(Entry)

        get :entries, params: { last_sync: '2010-06-01' }

        expect(Entry).to have_received(:since).with(DateTime.parse('2010-06-01'))
      end
    end
  end

  describe 'GET #categories' do
    context 'with no date provided' do
      let(:image_available) { true }
      let(:image_suitable) { true }
      let(:audio_available) { true }
      let(:audio_suitable) { true }

      before do
        allow(Category).to receive(:with_published_entries).and_return(Category)
        allow(Category).to receive(:by_display_order).and_return([category1, category2])

        allow(category1).to receive(:image_game_suitable?).and_return(image_suitable)
        allow(category1).to receive(:image_game_available?).and_return(image_available)
        allow(category1).to receive(:audio_game_suitable?).and_return(audio_suitable)
        allow(category1).to receive(:audio_game_available?).and_return(audio_available)
      end

      it 'returns all categories with published entries' do
        get :categories

        parsed_response = JSON.parse response.body

        expect(parsed_response['categories'].length).to eq(2)

        first_category = parsed_response['categories'].first
        expect(first_category['id']).to eq(37)
        expect(first_category['name']).to eq('Family')
        expect(first_category['images']['thumbnail']).to eq('cat_thumb1.png')
        expect(first_category['images']['normal']).to eq('cat_normal1.png')
      end

      context 'when category is both available and suitable for image/audio games' do
        it 'allows games' do
          get :categories

          parsed_response = JSON.parse response.body
          first_category = parsed_response['categories'].first

          expect(first_category['games']['image']).to be(true)
          expect(first_category['games']['audio']).to be(true)
        end
      end

      context 'when category is available but not suitable for image/audio games' do
        let(:image_suitable) { false }
        let(:audio_suitable) { false }

        it 'does not allow games' do
          get :categories

          parsed_response = JSON.parse response.body
          first_category = parsed_response['categories'].first

          expect(first_category['games']['image']).to be(false)
          expect(first_category['games']['audio']).to be(false)
        end
      end

      context 'when category is suitable but not available for image/audio games' do
        let(:image_available) { false }
        let(:audio_available) { false }

        it 'does not allow games' do
          get :categories

          parsed_response = JSON.parse response.body
          first_category = parsed_response['categories'].first

          expect(first_category['games']['image']).to be(false)
          expect(first_category['games']['audio']).to be(false)
        end
      end
    end

    context 'with a date provided' do
      before do
        allow(Category).to receive(:with_published_entries).and_return(Category)
        allow(Category).to receive(:since)
      end

      it 'returns all categories modified after the provided date' do
        get :categories, params: { last_sync: '2010-06-01' }

        expect(Category).to have_received(:with_published_entries)
        expect(Category).to have_received(:since)
      end
    end
  end

  describe 'GET #image_credits' do
    let(:credit1) do
      ImageCredit.new attribution_text: 'Saltwater Croc - PhotoGuy89 - CC SA-2.5', link: 'http://linktoapicture.com/1.png'
    end
    let(:credit2) do
      ImageCredit.new attribution_text: 'Red Flying Fox - PhotoGal90 - CC SA-3.0', link: 'http://linktoapicture.com/2.png'
    end
    let(:credits) { [credit1, credit2] }

    before { allow(ImageCredit).to receive(:with_attribution).and_return(credits) }

    it 'provides a list of all image credits' do
      get :image_credits

      parsed_response = JSON.parse response.body

      expect(parsed_response['image_credits'].length).to eq(2)

      first_credit = parsed_response['image_credits'].first
      expect(first_credit['id']).to eq(nil)
      expect(first_credit['attribution_text']).to eq('Saltwater Croc - PhotoGuy89 - CC SA-2.5')
      expect(first_credit['link']).to eq('http://linktoapicture.com/1.png')
    end
  end

  describe 'GET #all' do
    it 'aggregates all the syncable fields' do
      get :all

      parsed_response = JSON.parse response.body

      expect(parsed_response).to have_key('categories')
      expect(parsed_response).to have_key('entries')
      expect(parsed_response).to have_key('image_credits')
    end
  end
end
