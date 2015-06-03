class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :user_id, :video_id, :list_position
      t.timestamps
    end
  end
end
