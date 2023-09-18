class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :full_name
      t.string :language
      t.string :git_url
      t.string :ssh_url
      t.integer :github_id
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
