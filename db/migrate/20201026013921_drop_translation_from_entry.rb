class DropTranslationFromEntry < ActiveRecord::Migration
  def change
    remove_column :entries, :translation
  end
end
