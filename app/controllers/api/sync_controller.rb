class Api::SyncController < ApplicationController
  def categories
    last_sync = DateTime.parse(params[:since]) if params[:since]

    render json: categories_since(last_sync), root: 'categories', each_serializer: CategorySerializer
  end

	def entries
    last_sync = DateTime.parse(params[:since]) if params[:since]

	  render json: entries_since(last_sync), root: 'entries', each_serializer: EntrySerializer
	end

  def all
    last_sync = DateTime.parse(params[:since]) if params[:since]

    render json: {
      categories: categories_since(last_sync),
      entries: entries_since(last_sync)
    }, root: false, serializer: SyncSerializer
  end

  private

  def categories_since last_sync
    last_sync ? Category.since(last_sync) : Category.all
  end

  def entries_since last_sync
    entries = Entry

    entries = entries.since last_sync if last_sync

    entries.published?
  end
end
