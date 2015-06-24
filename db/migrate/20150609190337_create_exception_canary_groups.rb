class CreateExceptionCanaryGroups < ActiveRecord::Migration
  def change
    create_table :exception_canary_groups do |t|
      t.text :name
      t.integer :action
      t.integer :match_type
      t.text :value
      t.text :note
      t.boolean :is_auto_generated, default: true
      t.timestamps null: false
    end
  end
end
