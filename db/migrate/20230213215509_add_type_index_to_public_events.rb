class AddTypeIndexToPublicEvents < ActiveRecord::Migration[7.0]
  def change
    add_index :public_events, :type
    add_index :public_events, [:type, :duration]
  end
end
