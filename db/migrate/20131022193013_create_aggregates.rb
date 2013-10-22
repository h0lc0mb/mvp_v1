class CreateAggregates < ActiveRecord::Migration
  def change
    create_table :aggregates do |t|
      t.integer :user_id
      t.string :key
      t.integer :value

      t.timestamps
    end
  end
end
