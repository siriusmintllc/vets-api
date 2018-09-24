class CreateTimeOfNeedTimeOfNeedForms < ActiveRecord::Migration
  def change
    create_table :time_of_need_time_of_need_forms do |t|

      t.timestamps null: false
    end
  end
end
