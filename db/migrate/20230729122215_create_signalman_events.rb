class CreateSignalmanEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :signalman_events do |t|
      t.string :name
      t.datetime :started_at
      t.datetime :finished_at
      t.json :payload

      t.timestamps
    end
  end
end
