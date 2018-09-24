class CreateTimeOfNeedDecedents < ActiveRecord::Migration
  def change
    create_table :time_of_need_decedents do |t|
      t.string :firstName
      t.string :lastName
      t.string :middleName

      t.timestamps null: false
    end
  end
end
