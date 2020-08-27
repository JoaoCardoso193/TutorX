class CreateTutors < ActiveRecord::Migration[5.2]
  def change
    create_table :tutors do |t|
      t.string :name
      t.string :subject
      t.integer :years_of_experience
    end
  end
end
