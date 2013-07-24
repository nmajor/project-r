class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string "title"
      t.string "subtitle"
      t.text "blurb"
      t.text "excerpt"
      t.text "buy_link", :limit => 1500
      t.timestamps
    end
  end
end
