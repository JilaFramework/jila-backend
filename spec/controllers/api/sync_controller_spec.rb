require 'rails_helper'

RSpec.describe Api::SyncController, :type => :controller do
	describe 'GET #entries' do
    let(:category1) { double(Category, name: 'Family') }
    let(:category2) { double(Category, name: 'Body Parts') }
    let(:entry) { double(Entry, id: 37, entry_word: 'Mimi', translation: 'Grandma', categories: [category1, category2]) }

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
              translation: 'Grandma',
              categories: [
                'Family',
                'Body Parts'
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
