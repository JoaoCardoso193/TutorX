class Tutor < ActiveRecord::Base
    has_many :appointments
    has_many :students, through: :appointments

    def appointments
        Appointment.all.select{|appointment| appointment.tutor_id == self.id}
    end
end


