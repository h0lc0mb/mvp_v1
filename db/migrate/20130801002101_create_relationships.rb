class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_user_id
      t.integer :followed_course_id

      t.timestamps
    end

    add_index :relationships, :follower_user_id
    add_index :relationships, :followed_course_id
    add_index :relationships, [:follower_user_id, :followed_course_id], unique: true
  end
end
