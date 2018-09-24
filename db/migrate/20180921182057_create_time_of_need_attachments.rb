class CreateTimeOfNeedAttachments < ActiveRecord::Migration
  def change
    create_table :time_of_need_attachments do |t|

      t.timestamps null: false
    end
  end
end
