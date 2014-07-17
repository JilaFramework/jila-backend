require 'rails_helper'

RSpec.describe Api::SyncController, :type => :controller do
	let(:category1) { Category.new id: 37, name: 'Family' }
  let(:category2) { Category.new id: 24, name: 'Body Parts' }
  let(:entry) { Entry.new id: 3, entry_word: 'Mimi', 
                                 word_type: 'noun',
                                 translation: 'Grandma', 
                                 description: 'Mum\'s mum',
                                 categories: [category1, category2] }

  before do
    allow(entry).to receive_message_chain(:audio, :exists?).and_return(true)
    allow(entry).to receive_message_chain(:audio, :url).and_return('s3.m4a')
    allow(entry).to receive(:image).with(:thumbnail).and_return('thumb.png')
    allow(entry).to receive(:image).with(:normal).and_return('normal.png')
    allow(category1).to receive(:image).with(:thumbnail).and_return('cat_thumb1.png')
    allow(category1).to receive(:image).with(:normal).and_return('cat_normal1.png')
  end

  describe 'GET #entries' do
    before { expect(Entry).to receive(:published?).and_return([entry]) }

		context 'with no date provided' do
      it 'should return all published entries in JSON' do
        expect(Entry).to_not receive(:since)

        get :entries

        expect(response.body).to eq({
          entries: [
            {
              id: 3,
              entry_word: 'Mimi',
              word_type: 'noun',
              translation: 'Grandma',
              description: 'Mum\'s mum',
              audio: 's3.m4a',
              images: {
                thumbnail: 'thumb.png',
                normal: 'normal.png'
              },
              categories: [
                37,
                24
              ]
            }
          ]
        }.to_json)
      end
    end

    context 'with a date provided' do
      it 'should return all published entries since the provided date' do
        expect(Entry).to receive(:since).with(DateTime.parse('2010-06-01'))
                                        .and_return(Entry)

        get :entries, since: '2010-06-01'
      end
    end
	end

  describe 'GET #categories' do
    context 'with no date provided' do
      before { expect(Category).to receive(:all).and_return([category1, category2]) }

      it 'should return all categories' do
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
