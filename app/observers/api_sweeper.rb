class ApiSweeper < ActionController::Caching::Sweeper
  observe Category, Entry

  def after_save record
    fragment_path = ActionController::Caching::Actions::ActionCachePath.new(self, {
        controller: '/api/sync',
        action: 'all',
        format: 'json'
    }, false).path
    expire_fragment("#{fragment_path}.json")
  end
end 