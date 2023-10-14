class CreateRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_checks do |t|
      t.boolean :passed, default: false
      t.string :commit_hash
      t.integer :issues_count, default: 0
      t.string :aasm_state
      t.json :issues
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
