class CreateShortUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :short_urls do |t|
      t.string :short_url
      t.string :original_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
