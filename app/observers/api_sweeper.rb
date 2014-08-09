class ApiSweeper < ActionController::Caching::Sweeper
  observe Category, Entry

  def after_save record
    expire_action(:controller => "/api/sync", :action => "all")
  end
end 