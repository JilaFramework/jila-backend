# frozen_string_literal: true

class ImageCredit < ApplicationRecord
  belongs_to :entry

  def self.with_attribution
    where.not(attribution_text: nil).where.not(attribution_text: '')
  end
end
