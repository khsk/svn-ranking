class CreateCommitCollections < ActiveRecord::Migration
  def change
    create_table :commit_collections do |t|
      t.string :name
      t.integer :count
      t.string :date

      t.timestamps null: false
    end
  end
end
