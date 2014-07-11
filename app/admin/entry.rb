ActiveAdmin.register Entry do

  actions :all, except: [:show]

  permit_params :entry_word, :word_type, :translation, :description, :published?

  form do |f|
    f.inputs do
      f.input :entry_word
      f.input :word_type, as: :select, collection: Entry::WORD_TYPES
      f.input :translation
      f.input :description
      f.input :published?
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
    actions
  end
end
