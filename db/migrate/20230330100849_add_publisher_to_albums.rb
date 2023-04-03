class AddPublisherToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :publisher, :boolean, default: true
  end
end
