class AddingStudentPassword < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :password, :string    
  end
end
