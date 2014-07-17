require 'rails_helper'

RSpec.describe Category, :type => :model do
  let!(:tomorrow) { Category.create name: 'tomorrow', updated_at: Date.tomorrow }
  let!(:yesterday) { Category.create name: 'yesterday', updated_at: Date.yesterday }

  describe :since do
    it 'should filter categories modified before provided date' do
      categories = Category.since Date.today.to_s

      expect(categories).to_not include(yesterday)
      expect(categories).to include(tomorrow)
    end
  end
end
