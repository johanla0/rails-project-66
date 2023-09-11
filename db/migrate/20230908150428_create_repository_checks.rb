class CreateRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_checks do |t|
      t.boolean :result, default: false
      t.string :commit
      t.integer :issue_count, default: 0
      t.string :state
      t.json :issues
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
