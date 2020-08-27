class Student < ActiveRecord::Base
    has_many :appointments
    has_many :tutors, through: :appointments

    #creates and returns an hour long appointment, uses 24hr format

    ## work hours defined, if outside that range, drop error. also drop error if appointment already taken
    def create_appointment(tutor, year, month, day, hour, note)
        datetime = DateTime.new(year, month, day, hour)
        appointment = Appointment.find_by(begin_datetime: datetime, tutor_id: tutor.id)
        if appointment.taken == false
            appointment.taken = true
            appointment.student_id = self.id
            appointment.tutor_id = tutor.id
            appointment.note = note
            appointment.end_datetime = appointment.begin_datetime + 1.hours
            appointment.save
            appointment
        else
            puts "\nAppointment taken, please select another time slot".red.bold
            return 'failed'
        end
    end

    #cancels an appointment given its id
    def cancel_appointment(appointment_id)
        appointment = appointments.find {|appointment| appointment.id == appointment_id}
        appointment.student_id = nil
        appointment.taken = false
        appointment.note = nil
        appointment.end_datetime = nil
        appointment.save
    end

    #returns all appointments for student instance
    def appointments
        Appointment.all.select{|appointment| appointment.student_id == self.id}
    end

    #returns upcoming appointment for student instance
    def upcoming_appointments
        appointments.select{|appointment| appointment.begin_datetime > DateTime.now}
    end
end