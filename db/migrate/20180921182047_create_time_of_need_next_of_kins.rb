class CreateTimeOfNeedNextOfKins < ActiveRecord::Migration
  def change
    create_table :time_of_need_next_of_kins do |t|

      t.timestamps null: false
    end
  end
end
