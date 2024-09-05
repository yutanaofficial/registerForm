class CreateRegisters < ActiveRecord::Migration[7.2]
  def change
    create_table :registers do |t|
      t.string :fistName
      t.string :lastName
      t.date :birthDay
      t.string :gender
      t.string :email
      t.string :phoneNumber
      t.string :subJect

      t.timestamps
    end
  end
end
