class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.datetime :begin_datetime
      t.datetime :end_datetime
      t.string :note
      t.integer :student_id
      t.integer :tutor_id
    end
  end
end
