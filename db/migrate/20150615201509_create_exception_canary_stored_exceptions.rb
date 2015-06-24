class CreateExceptionCanaryStoredExceptions < ActiveRecord::Migration
  def change
    create_table :exception_canary_stored_exceptions do |t|
      t.integer :rule_id, limit: 8
      t.text :title
      t.text :backtrace
      t.text :environment
      t.text :variables
      t.string :klass
      t.timestamps null: false
    end
    add_index 'exception_canary_stored_exceptions', [:rule_id]
  end
end
