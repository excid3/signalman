class CreateSignalmanEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :signalman_events do |t|
      t.string :name
      t.datetime :started_at
      t.datetime :finished_at
      t.float :duration
      t.json :payload

      t.timestamps
    end

    add_index :signalman_events, [:name, :duration]
  end
end
