class CreateReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :replies do |t|
      t.text :content
      t.belongs_to :memo, foreign_key: true

      t.timestamps
    end
  end
end
