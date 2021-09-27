# frozen_string_literal: true

ActiveAdmin.register Entry do
  action_item only: :index do
    link_to 'Upload CSV', action: 'upload_csv'
  end

  collection_action :upload_csv do
    render 'admin/csv/upload_csv'
  end

  collection_action :import_csv, method: :post do
    EntriesCSVImporter.convert_save(params[:dump][:file])
    redirect_to action: :index, notice: 'CSV imported successfully!'
  end

  controller do
    cache_sweeper :api_sweeper

    def create
      create! do |format|
        format.html { redirect_to edit_admin_entry_path(Entry.last) }
      end
    end

    def update
      update! do |format|
        format.html { redirect_to edit_admin_entry_path }
      end
    end
  end

  actions :all, except: [:show]

  permit_params :entry_word, :word_type, :pronunciation, :meaning, :example, :example_translation, :alternate_translations_raw, :alternate_spellings_raw, :display_order, :description,
                :published?, :image, :audio, image_credit_attributes: %i[attribution_text link], category_ids: []

  form(html: { multipart: true }) do |f|
    f.inputs 'Details' do
      f.input :entry_word
      f.input :word_type, as: :select, collection: Entry::WORD_TYPES
      f.input :pronunciation
      f.input :meaning
      f.input :alternate_translations_raw, as: :text, label: 'Alternate translations - One per line',
                                           placeholder: 'One per line', input_html: { rows: 3 }
      f.input :alternate_spellings_raw, as: :text, label: 'Alternate spellings - One per line',
                                        placeholder: 'One per line', input_html: { rows: 3 }
      f.input :description
      f.input :example
      f.input :example_translation
      f.input :display_order, hint: 'optional - if not specified will be sorted alphabetically'
      f.input :published?
    end

    f.inputs 'Image' do
      f.input :image, as: :file, label: 'Image - Must be JPEG, PNG or GIF', hint: thumbnail_image(f.object)
      f.inputs 'Image Credit', for: [:image_credit, f.object.image_credit || ImageCredit.new] do |icf|
        icf.input :attribution_text
        icf.input :link
      end
    end

    f.inputs 'Audio' do
      f.input :audio, as: :file, label: 'Audio - Must be MP3 or M4A (AAC)', hint: audio_link(f.object)
    end

    f.inputs 'Select categories' do
      f.input :categories, as: :check_boxes, collection: Category.all.sort_by(&:name)
    end

    f.actions
  end

  batch_action :publish do |selection|
    Entry.find(selection).each { |e| e.update_attribute(:published?, true) }
    redirect_to collection_path, notice: 'Entries published'
  end

  batch_action :un_publish do |selection|
    Entry.find(selection).each { |e| e.update_attribute(:published?, false) }
    redirect_to collection_path, notice: 'Entries un-published'
  end

  index do
    selectable_column
    column :entry_word do |entry|
      link_to entry.entry_word, edit_admin_entry_path(entry)
    end
    column :word_type
    column :pronunciation
    column :meaning
    column :example
    column :example_translation
    column :published?
    column 'Order', :display_order
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
  filter :meaning
  filter :published?, as: :select, collection: [true, false]
end
