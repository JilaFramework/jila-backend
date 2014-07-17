class Api::SyncController < ApplicationController

	def entries
    last_sync = DateTime.parse(params[:since]) if params[:since]

	  render json: entries_since(last_sync), root: 'entries', each_serializer: EntrySerializer
	end

  def all
    last_sync = DateTime.parse(params[:since]) if params[:since]

    render json: {
      categories: [],
      entries: entries_since(last_sync)
    }, root: false, serializer: SyncSerializer
  end

  private

  def entries_since last_sync
    entries = Entry

    entries = entries.since last_sync if last_sync

    entries.published?
  end
end
