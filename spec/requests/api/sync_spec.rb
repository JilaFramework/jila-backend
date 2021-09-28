# frozen_string_literal: true

require 'swagger_helper'
# rubocop:disable RSpec/LetSetup
# rubocop:disable RSpec/ScatteredSetup
# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe 'api/sync', type: :request do
  before(:all) do
    ApiSweeper.disabled = true
  end

  after(:all) do
    Category.delete_all
    Entry.delete_all
  end

  let!(:last_sync) { '2010-06-01' }
  let!(:category) { Category.create name: 'common phrases', position: 99 }
  let!(:entry) do
    Entry.create entry_word: 'Jalangardi', word_type: 'noun', meaning: 'Goanna',
                 alternate_translations: ['Sand Monitor'], alternate_spellings: ['alternate spelling 1'],
                 description: 'description', published?: true, categories: [category]
  end

  path '/api/sync/categories' do
    get('categories sync') do
      tags 'Categories'
      produces 'application/json'
      parameter name: :last_sync, in: :query, type: :string
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/sync/entries' do
    get('entries sync') do
      tags 'Entries'
      produces 'application/json'
      parameter name: :last_sync, in: :query, type: :string
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/sync/image_credits' do
    get('image_credits sync') do
      tags 'Image Credits'
      produces 'application/json'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        let!(:image_credit) do
          ImageCredit.create(attribution_text: 'Saltwater Crocodile - MR Jordan Woodside - CC BY-SA 3.0',
                             link: 'http://link.to.image.png')
        end
        run_test!
      end
    end
  end

  path '/api/sync/all' do
    get('all sync') do
      tags 'All'
      produces 'application/json'
      parameter name: :last_sync, in: :query, type: :string
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        let!(:image_credit) do
          ImageCredit.create(attribution_text: 'Saltwater Crocodile - MR Jordan Woodside - CC BY-SA 3.0',
                             link: 'http://link.to.image.png')
        end
        run_test!
      end
    end
  end
end
# rubocop:enable RSpec/LetSetup
# rubocop:enable RSpec/ScatteredSetup
# rubocop:enable RSpec/EmptyExampleGroup
