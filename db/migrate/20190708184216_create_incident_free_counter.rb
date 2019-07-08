class CreateIncidentFreeCounter < ActiveRecord::Migration[5.2]
  def change
    create_table :incident_free_counters do |t|
      t.bigint :days_since_incident
    end
  end
end
