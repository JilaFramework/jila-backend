class ApiSweeper < ActionController::Caching::Sweeper
  observe Category, Entry

  @@disabled = false

  def self.disabled= new_state
    # puts "Setting API sweeper state to disabled: #{new_state}"
    @@disabled = new_state
  end

  def after_save record
    expire_cache
  end

  def after_destroy record
    expire_cache
  end

  private

  def expire_cache
    unless @@disabled
      fragment_path = ActionController::Caching::Actions::ActionCachePath.new(self, {
          controller: '/api/sync',
          action: 'all',
          format: 'json'
      }, false).path
      expire_fragment("#{fragment_path}.json")
    end
  end
end 