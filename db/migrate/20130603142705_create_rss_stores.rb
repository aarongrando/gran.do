class CreateRssStores < ActiveRecord::Migration
  def change
    create_table :rss_stores do |t|
      t.text :xml
      t.timestamps
    end
  end
end
