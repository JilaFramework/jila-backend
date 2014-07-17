class Api::SyncController < ApplicationController

	def entries
    entries = Entry

    if params[:since]
      since = DateTime.parse(params[:since])
      entries = entries.since since
    end

    entries = entries.published?

	  render json: {
      entries: entries.map do |e|
                {
                  id: e.id,
                  entry_word: e.entry_word,
                  translation: e.translation,
                  categories: e.categories.map(&:name)
                }
               end
    }
	end
end
