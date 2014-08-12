class ImageCredit < ActiveRecord::Base
  belongs_to :entry

  def self.with_attribution
    where('attribution_text IS NOT NULL').where('attribution_text != ?', '')
  end
end
