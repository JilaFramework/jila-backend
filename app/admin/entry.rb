ActiveAdmin.register Entry do

  actions :all, except: [:show]

  permit_params :entry_word, :word_type, :translation, :description, 
                :published?, :image, :audio, category_ids: []

  form(html: { multipart: true }) do |f|
    f.inputs 'Details' do
      f.input :entry_word
      f.input :word_type, as: :select, collection: Entry::WORD_TYPES
      f.input :translation
      f.input :description
      f.input :published?
      f.input :image, as: :file
      f.input :audio, as: :file
    end

    f.inputs 'Existing Image' do
      thumbnail_image f.object
    end

    f.inputs 'Existing Audio' do
      audio_link f.object
    end

    f.inputs 'Select categories' do
      f.input :categories, as: :check_boxes, collection: Category.all
    end

    f.actions
  end

  index do
    column :entry_word do |entry|
      link_to entry.entry_word, edit_admin_entry_path(entry)
    end
    column :word_type
    column :translation
    column :description
    column :published?
    column :image do |entry|
      thumbnail_image entry
    end
    column :audio do |entry|
      audio_link entry
    end
    column :categories do |entry|
      entry.categories.map do |c|
        span c.name, class: 'category'
      end 
    end
    actions
  end
end
