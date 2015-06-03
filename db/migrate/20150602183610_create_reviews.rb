class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :body
      t.integer :rating, :video_id, :user_id

      t.timestamps
    end
  end
end
