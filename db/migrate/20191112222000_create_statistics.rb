class CreateStatistics < ActiveRecord::Migration[5.2]
  def change
    create_table :statistics do |t|
      t.bigint :monthly_high
      t.bigint :all_time_high
      t.date :monthly_high_date
      t.date :all_time_high_date
    end
  end
end
