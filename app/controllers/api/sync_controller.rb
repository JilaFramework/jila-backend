class Api::SyncController < ApplicationController

	def entries
    entries = Entry

    if params[:since]
      since = DateTime.parse(params[:since])
      entries = entries.since since
    end

    entries = entries.published?

	  render json: entries, root: 'entries', each_serializer: EntrySerializer
	end
end
