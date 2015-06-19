class CreateExceptionCanaryStoredExceptions < ActiveRecord::Migration
  def change
    create_table :exception_canary_stored_exceptions do |t|
      t.belongs_to :rule
      t.string :title
      t.string :backtrace
      t.string :environment
      t.string :variables
      t.string :klass
      t.timestamps null: false
    end
  end
end
