class CreateSearchLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :search_logs do |t|
      t.string :query
      t.string :ip_address
      t.string :country
      t.string :operating_system
      t.string :status
      t.integer :search_count
      t.datetime :last_searched

      t.timestamps
    end
  end
end
