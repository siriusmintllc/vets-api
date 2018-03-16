class AlterBaseFacilitiesChangeLatAndLongToStrings < ActiveRecord::Migration
  def change
    change_column :base_facilities, :lat, :string, null: false
    change_column :base_facilities, :long, :string, null: false
  end
end
