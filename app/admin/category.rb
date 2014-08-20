ActiveAdmin.register Category do
  controller do
    cache_sweeper :api_sweeper

    def create
      create! do |format|
        format.html { redirect_to edit_admin_category_path(Category.last) }
      end
    end

    def update
      update! do |format|
        format.html { redirect_to edit_admin_category_path }
      end
    end
  end

  config.sort_order = 'position_asc'
  config.paginate = false
  sortable

  actions :all, except: [:show]

  permit_params :name, :image, :image_game_available?, :audio_game_available?

  form(html: { multipart: true }) do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :image, as: :file, label: 'Image - Must be JPEG, PNG or GIF', hint: thumbnail_image(f.object)
    end

    f.inputs 'Game Settings' do
      f.input :image_game_available?, 
              label: 'Available for picture games?', 
              hint: picture_hint(f.object),
              input_html: {disabled: !f.object.image_game_suitable?}
      f.input :audio_game_available?, 
              label: 'Available for audio games?', 
              hint: audio_hint(f.object),
              input_html: {disabled: !f.object.audio_game_suitable?}
    end
    
    f.actions
  end

  index do
    sortable_handle_column
    column :name do |category|
      link_to category.name, edit_admin_category_path(category)
    end
    column :image do |entry|
      thumbnail_image entry
    end
    actions
  end
  
  filter :name
end
