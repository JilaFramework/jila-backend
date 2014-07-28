require 'rails_helper'

RSpec.describe Api::SyncController, :type => :controller do
	let(:category1) { Category.new id: 37, name: 'Family' }
  let(:category2) { Category.new id: 24, name: 'Body Parts' }
  let(:entry) { Entry.new id: 3, entry_word: 'Mimi', 
                                 word_type: 'noun',
                                 translation: 'Grandma', 
                                 alternate_translations: ['Granny'],
                                 description: 'Mum\'s mum',
                                 categories: [category1, category2] }

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
    before { expect(Entry).to receive(:published?).and_return([entry]) }

		context 'with no date provided' do
      it 'should return all published entries in JSON' do
        expect(Entry).to_not receive(:since)

        get :entries

        parsed_response = JSON.parse response.body

        expect(parsed_response['entries'].length).to eq(1)

        first_entry = parsed_response['entries'].first
        expect(first_entry['id']).to eq(3)
        expect(first_entry['entry_word']).to eq('Mimi')
        expect(first_entry['word_type']).to eq('noun')
        expect(first_entry['translation']).to eq('Grandma')
        expect(first_entry['alternate_translations']).to eq(['Granny'])
        expect(first_entry['description']).to eq('Mum\'s mum')
        expect(first_entry['audio']).to eq('s3.m4a')
        expect(first_entry['images']['thumbnail']).to eq('thumb.png')
        expect(first_entry['images']['normal']).to eq('normal.png')
        expect(first_entry['categories']).to eq([37,24])
        
      end
    end

    context 'with a date provided' do
      it 'should return all published entries modified after the provided date' do
        expect(Entry).to receive(:since).with(DateTime.parse('2010-06-01'))
                                        .and_return(Entry)

        get :entries, last_sync: '2010-06-01'
      end
    end
	end

  describe 'GET #categories' do
    context 'with no date provided' do
      before { expect(Category).to receive(:with_published_entries).and_return([category1, category2]) }

      it 'should return all categories with published entries' do
        get :categories

        parsed_response = JSON.parse response.body

        expect(parsed_response['categories'].length).to eq(2)

        first_category = parsed_response['categories'].first
        expect(first_category['id']).to eq(37)
        expect(first_category['name']).to eq('Family')
        expect(first_category['images']['thumbnail']).to eq('cat_thumb1.png')
        expect(first_category['images']['normal']).to eq('cat_normal1.png')
      end
    end

    context 'with a date provided' do
      before { expect(Category).to receive(:with_published_entries).and_return(Category) }
      before { expect(Category).to receive(:since) }

      it 'should return all categories modified after the provided date' do
        get :categories, last_sync: '2010-06-01'
      end
    end
  end

  describe 'GET #all' do
    it 'should aggregate all the syncable fields' do
      get :all

      parsed_response = JSON.parse response.body

      expect(parsed_response).to have_key('categories')
      expect(parsed_response).to have_key('entries')
    end 
  end
end
