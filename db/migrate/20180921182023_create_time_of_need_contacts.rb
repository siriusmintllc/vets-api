class CreateTimeOfNeedContacts < ActiveRecord::Migration
  def change
    create_table :time_of_need_contacts do |t|

      t.timestamps null: false
    end
  end
end
