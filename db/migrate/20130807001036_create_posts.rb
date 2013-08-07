class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :follower_user_id
      t.integer :followed_course_id

      t.timestamps
    end
    # I think I need to couple both indices because
    	# at some point I'll want to do both of the following:
    		# 1. Retrieve all posts associated with a given follower_user_id
    			# in the reverse order of creation
    		# 2. Retrieve all posts associated with a given followed_course_id
    			# in the reverse order of creation
    add_index :posts, [:follower_user_id, :created_at]
    add_index :posts, [:followed_course_id, :created_at]
  end
end
