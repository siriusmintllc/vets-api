class CreateTimeOfNeedVeterans < ActiveRecord::Migration
  def change
    create_table :time_of_need_veterans do |t|

      t.timestamps null: false
    end
  end
end
