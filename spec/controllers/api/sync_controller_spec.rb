require 'rails_helper'

RSpec.describe Api::SyncController, :type => :controller do
	describe 'GET #entries' do
		context 'with no date provided' do
      let(:category1) { double(Category, name: 'Family') }
      let(:category2) { double(Category, name: 'Body Parts') }
      let(:entry) { double(Entry, id: 37, entry_word: 'Mimi', translation: 'Grandma', categories: [category1, category2]) }

      it 'should return all published entries in JSON' do
        expect(Entry).to receive(:published?).and_return([entry])

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
	end	
end
