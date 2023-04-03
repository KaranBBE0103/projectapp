class Album < ApplicationRecord
    has_many_attached :videos
    has_one_attached :coverimg
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }
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
