class CreateTimeOfNeedFuneralHomes < ActiveRecord::Migration
  def change
    create_table :time_of_need_funeral_homes do |t|

      t.timestamps null: false
    end
  end
end
