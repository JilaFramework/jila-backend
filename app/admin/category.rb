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

  actions :all, except: [:show]

  permit_params :name, :image

  form(html: { multipart: true }) do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :image, as: :file, label: 'Image - Must be JPEG, PNG or GIF', hint: thumbnail_image(f.object)
    end
    
    f.actions
  end

  index do
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
