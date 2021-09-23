# frozen_string_literal: true

module Api
  class SyncController < ApplicationController
    caches_action :all

    def categories
      last_sync = DateTime.parse(params[:last_sync]) if params[:last_sync]

      render json: { categories: categories_since(last_sync) }
    end

    def entries
      last_sync = DateTime.parse(params[:last_sync]) if params[:last_sync]

      render json: { entries: entries_since(last_sync) }
    end

    def image_credits
      render json: { image_credits: image_credit_with_attribution }
    end

    def all
      last_sync = DateTime.parse(params[:last_sync]) if params[:last_sync]

      render json: {
        categories: categories_since(last_sync),
        entries: entries_since(last_sync),
        image_credits: image_credit_with_attribution
      }
    end

    private

    def categories_since(last_sync)
      categories = Category.with_published_entries.by_display_order
      result = last_sync ? categories.since(last_sync) : categories
      (result || []).map(&:serialize)
    end

    def entries_since(last_sync)
      entries = Entry

      entries = entries.since last_sync if last_sync

      (entries.by_display_order.alphabetically.published? || []).map(&:serialize)
    end

    def image_credit_with_attribution
      (ImageCredit.with_attribution || []).map do |image_credit|
        {
          attribution_text: image_credit.attribution_text,
          link: image_credit.link
        }
      end
    end
  end
end
