class CreateDrawings < ActiveRecord::Migration[5.2]
  def change
    create_table :drawings do |t|
      t.string :name
      t.string :strokes # serialized
    end
  end
end
