class Api::SyncController < ApplicationController
  caches_action :all

  def categories
    last_sync = DateTime.parse(params[:last_sync]) if params[:last_sync]

    render json: categories_since(last_sync), root: 'categories', each_serializer: CategorySerializer
  end

	def entries
    last_sync = DateTime.parse(params[:last_sync]) if params[:last_sync]

	  render json: entries_since(last_sync), root: 'entries', each_serializer: EntrySerializer
	end

  def image_credits
    render json: ImageCredit.with_attribution, root: 'image_credits', each_serializer: ImageCreditSerializer
  end

  def all
    last_sync = DateTime.parse(params[:last_sync]) if params[:last_sync]

    render json: {
      categories: categories_since(last_sync),
      entries: entries_since(last_sync),
      image_credits: ImageCredit.with_attribution,
    }, root: false, serializer: SyncSerializer
  end

  private

  def categories_since last_sync
    categories = Category.with_published_entries
    last_sync ? categories.since(last_sync) : categories
  end

  def entries_since last_sync
    entries = Entry

    entries = entries.since last_sync if last_sync

    entries.published?
  end
end
