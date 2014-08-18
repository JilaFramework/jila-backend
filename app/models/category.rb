class Category < ActiveRecord::Base
	validates :name, presence: true

  has_and_belongs_to_many :entries
  acts_as_list

	has_attached_file :image, styles: {
	  thumbnail: '250x250>',
	  normal: '640x640>',
	  large: '800x800>',
	  xlarge: '1280x1280>'
	}
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def self.since updated_since
    where('updated_at >= ?', updated_since)
  end

  def self.with_published_entries
    joins(:entries).where(entries: {published?: true}).uniq
  end
end
