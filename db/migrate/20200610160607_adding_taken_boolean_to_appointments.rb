class AddingTakenBooleanToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :taken, :boolean, :default => 0
  end
end
