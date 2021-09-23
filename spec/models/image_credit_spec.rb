# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageCredit, type: :model do
  let!(:with) do
    described_class.create attribution_text: 'Saltwater Crocodile - MR Jordan Woodside - CC BY-SA 3.0',
                           link: 'http://link.to.image.png'
  end
  let!(:without_empty) { described_class.create attribution_text: '', link: '' }
  let!(:without_null) { described_class.create attribution_text: nil, link: '' }

  describe '#with_attribution' do
    it 'images credits without attributions' do
      image_credits = described_class.with_attribution

      expect(image_credits).not_to include(without_empty)
      expect(image_credits).not_to include(without_null)
      expect(image_credits).to include(with)
    end
  end
end
