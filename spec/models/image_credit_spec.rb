require 'rails_helper'

RSpec.describe ImageCredit, :type => :model do
  let!(:with) { ImageCredit.create attribution_text: 'Saltwater Crocodile - MR Jordan Woodside - CC BY-SA 3.0', link: 'http://link.to.image.png'}
  let!(:without_empty) { ImageCredit.create attribution_text: '', link: ''}
  let!(:without_null) { ImageCredit.create attribution_text: nil, link: ''}

  describe :with_attribution do
    it 'should image credits without attributions' do
      image_credits = ImageCredit.with_attribution

      expect(image_credits).to_not include(without_empty)
      expect(image_credits).to_not include(without_null)
      expect(image_credits).to include(with)
    end
  end
end