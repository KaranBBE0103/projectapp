class Album < ApplicationRecord
    has_many_attached :videos
    has_one_attached :coverimg
    has_many :taggings
    has_many :tags, through: :taggings
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }
    def self.tagged_with(name)
      Tag.find_by!(name: name).albums
    end
  
    def self.tag_counts
      Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
    end
  
    def tag_list
      tags.map(&:name).join(', ')
    end
  
    def tag_list=(names)
      self.tags = names.split(',').map do |n|
        Tag.where(name: n.strip).first_or_create!
      end
    end
    def self.ransackable_attributes(auth_object = nil)
      ["body", "created_at", "id", "publisher", "title", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
      ["coverimg_attachment", "coverimg_blob", "videos_attachments", "videos_blobs"]
    end
    ransacker :title_cont do
      Arel::Nodes::SqlLiteral.new("lower(title) like '%#{Ransack::Helpers::Sanitize.sanitize(query).downcase}%'")
    end
    private def album_params
        params.require(:album).permit(:title, :description, :publisher)
    end
end
