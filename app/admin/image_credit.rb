ActiveAdmin.register ImageCredit do
  controller do
    cache_sweeper :api_sweeper
  end

  actions :all, except: [:show]

  permit_params :attribution_text, :link

  filter :attribution_text
end
