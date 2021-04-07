class CreateUsers < ActiveRecord::Migration::Current
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
