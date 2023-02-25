class CreatePublicEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :public_events do |t|
      t.string :type
      t.string :name
      t.daterange :duration

      t.timestamps
    end
    add_index :public_events, :duration, using: 'GIST'
  end
end
