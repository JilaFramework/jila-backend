require 'rails_helper'

RSpec.describe Api::SyncController, :type => :controller do
	describe 'GET #entries' do
    let(:category1) { Category.new id: 37 }
    let(:category2) { Category.new id: 24 }
    let(:entry) { Entry.new id: 37, entry_word: 'Mimi', 
                                    word_type: 'noun',
                                    translation: 'Grandma', 
                                    description: 'Mum\'s mum',
                                    categories: [category1, category2] }

    before do
      allow(entry).to receive_message_chain(:audio, :url).and_return('s3.m4a')
      allow(entry).to receive(:image).with(:thumbnail).and_return('thumb.png')
      allow(entry).to receive(:image).with(:normal).and_return('normal.png')
    end

    before { expect(Entry).to receive(:published?).and_return([entry]) }

		context 'with no date provided' do
      it 'should return all published entries in JSON' do
        expect(Entry).to_not receive(:since)

        get :entries

        expect(response.body).to eq({
          entries: [
            {
              id: 37,
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
end
