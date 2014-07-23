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
      f.input :image, as: :file, label: 'Image - Must be JPEG, PNG or GIF'
      f.input :audio, as: :file, label: 'Audio - Must be MP3 or M4A (AAC)'
    end

    f.inputs 'Existing Image' do
      thumbnail_image f.object
    end

    f.inputs 'Existing Audio' do
      audio_link f.object
    end

    f.inputs 'Select categories' do
      f.input :categories, as: :check_boxes, collection: Category.all.sort_by(&:name)
    end

    f.actions
  end

  batch_action :publish do |selection|
    Entry.find(selection).each { |e| e.update_attribute(:published?, true) }
    redirect_to collection_path, :notice => "Entries published"
  end

  batch_action :un_publish do |selection|
    Entry.find(selection).each { |e| e.update_attribute(:published?, false) }
    redirect_to collection_path, :notice => "Entries un-published"
  end

  index do
    selectable_column
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

  filter :categories
  filter :entry_word
  filter :translation
  filter :published?, as: :select, collection: [true, false]
end
