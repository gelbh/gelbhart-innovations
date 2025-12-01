class CreateKeepAlive < ActiveRecord::Migration[8.1]
  def change
    create_table :keep_alive do |t|
      t.timestamps
    end
  end
end
