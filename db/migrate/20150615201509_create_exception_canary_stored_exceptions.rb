class CreateExceptionCanaryStoredExceptions < ActiveRecord::Migration
  def change
    create_table :exception_canary_stored_exceptions do |t|
      t.belongs_to :rule
      t.text :title
      t.text :backtrace
      t.text :environment
      t.text :variables
      t.string :klass
      t.timestamps null: false
    end
  end
end
