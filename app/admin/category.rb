ActiveAdmin.register Category do

  actions :all, except: [:show]

  permit_params :name, :image

  form(html: { multipart: true }) do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :image, as: :file
    end

    f.inputs 'Existing Image' do
      thumbnail_image f.object
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
  
end
