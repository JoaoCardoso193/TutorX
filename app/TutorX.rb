class App < TTY::Prompt
  attr_reader :student
  # here will be your CLI!
  # it is not an AR class so you need to add attr

  def run
    # welcome
    login_or_signup
    main_menu
  end

  private

  #method to get user input as an integer corresponding to an option
  #parameter 's' is the string printed to request user input, parameter 'limits' is the range of integers allowed as input
  def int_input(s = "\nPlease select an option:".yellow.bold, limits = [1, 100])
    puts s
    user_input = gets.chomp
    #if user types 'exit', exit the application
    if user_input.downcase == "exit"
      exit()
    end

    #if user input is within allowed range, return it, otherwise, ask for it again
    if user_input.to_i >= limits[0] and user_input.to_i <= limits[1]
        return user_input.to_i
    else
        puts("Invalid input, please enter an integer value coresponding to an option, or type 'exit' to exit application:".red.bold)
        sleep(1)
        return int_input(s, limits)
    end
  end



  #method to enumerate out options in a menu
  def enumerate_options(options)
    puts "\n"
    options.each_with_index do |option, index|
      puts "[#{index+1}] #{option}"
    end
  end



  # #prints welcome message
  # def welcome
  #   "Hello! Welcome to our app"
  #   #sleep for a bit
  #   sleep(0.3)
  #   system 'clear'
  # end


  #login method
  def login_or_signup
    system 'clear'
    #login prompt, gets user input
    puts "Please enter your username to sign up or log in:".yellow.bold
    name = gets.chomp.capitalize
    
    #checking for 'exit'
    if name.downcase == "exit"
      exit
    end

    #checking if student already exists, if not, ask for age and create a new student instance
    student_names = Student.all.map{|student| student.name}

    if student_names.include?(name)
      @student = Student.find_by(name: name)
      # puts "Please enter password"
      # sleep(0.3)
      # password = gets.chomp
     password = mask("Please enter your password:".yellow.bold) 
      # if password == "exit"
      #   exit 
      # end
      if @student.password != password
        system 'clear'
        puts "Incorrect password, please try again:".red.bold 
        sleep(0.5)
        login_or_signup
      end 
    else
      print "Please enter your age:".yellow.bold  
      age = int_input(s = "", limits = [1, 150])
      # puts "Please enter a password"
      # sleep(0.3)
      # password = gets.chomp 
      password = mask("Please enter your password:".yellow.bold) 
      @student = Student.create(name: name, age: age, password: password)
    end

    #sleep briefly
    sleep(1.5)

    #Welcome student and print main logo
    system 'clear'
    MainLogo.animate
    sleep(0.5)
    puts "\nWelcome #{@student.name}!".blue.bold 
    sleep(1.5)
  end



  def main_menu
    system 'clear'

    TextLogo.display

    #presents options to student 
    enumerate_options(['Make an appointment', 'View upcoming appointments', 'Exit'])
    user_input = int_input(s = "\nPlease select an option:".yellow.bold, limits = [1, 3])
    
    #Taking user to secondary menu depending on input
    if user_input == 1
      create_appointment_menu
    end
    if user_input == 2
      view_upcoming_appointments_menu
    end
    if user_input == 3
      system 'clear'
      exit
    end
    
  end

  def create_appointment_menu
    system 'clear'

    #Show all tutors
    puts "Available tutors:".magenta.bold  
    tutors = Tutor.all.map { |tutor| "Name: #{tutor.name}, Subject: #{tutor.subject}, Years of experience: #{tutor.years_of_experience}"}
    enumerate_options(tutors)

    #requesting and storing user input
    tutor = Tutor.find_by(id: int_input(s = "\nPlease select a tutor:".yellow.bold, limits = [1, tutors.size]))

    #requesting appointment month
    months = {1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June", 7 => "July", 8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December"}
    enumerate_options(months.values)
    month = int_input(s = "\nPlease select a month:".yellow.bold, limits = [1, 12])

    #requesting appointment day
    day = int_input(s = "\nPlease input a day:".yellow.bold, limits = [1, 31])

    #requesting an hour
    good_appts = tutor.appointments.select{|appt| appt.taken == false && appt.begin_datetime.day == day && appt.begin_datetime.mon == month}
    if good_appts.size == 0 #considering the case when there are no appointments left
      current_day = DateTime.new(DateTime.now.year, month, day)
      if current_day.wday == 6 || current_day.wday == 0
        system 'clear'
        puts "Tutors don't work on weekends!".red.bold
        sleep (1.5)
        create_appointment_menu
      else
        system 'clear'
        puts 'No appointments available with this tutor on this day!'.red.bold
        sleep (1.5)
        create_appointment_menu
      end 
    end
    display_hours = good_appts.map{|appt| "Start time: #{appt.begin_datetime.hour}.00 o'clock"}
    enumerate_options(display_hours)
    index = int_input(s = "\nPlease select an option:".yellow.bold, limits = [1, good_appts.size])
    hour = good_appts[index - 1].begin_datetime.hour 

    #requesting note
    puts "\nPlease leave a note:".yellow.bold 
    note = gets.chomp
    system 'clear'

    #creating appointment
    appointment = @student.create_appointment(tutor, DateTime.now.year, month, day, hour, note)
    if appointment != 'failed'
      puts "\nAppointment created successfully on #{months[month]}, #{day} at #{hour} o'clock!".green.bold 
      sleep(1.5)
    end

    #returning home
    enumerate_options(['Create Another Appointment', 'Home'])
    user_input = int_input(s = "\nPlease select an option:".yellow.bold, limits = [1, 2])
    if user_input == 1
      create_appointment_menu
    end
    if user_input == 2
      main_menu
    end
  end

  def view_upcoming_appointments_menu
    system 'clear'
    puts 'Upcoming Appointments:'.bold.magenta
    #save appointments as pretty strings and enumerate them
    appointments = @student.upcoming_appointments

    #return to main menu if there are no upcoming appointments
    if appointments.size == 0
      puts 'You have no upcoming appointments.'.red.bold 
      sleep(1.5)
      enumerate_options(['Make an appointment', 'Home'])
      user_input = int_input(s = "\nPlease select an option:".yellow.bold, limits = [1, 2])

      if user_input == 1
        create_appointment_menu
      end

      if user_input == 2
        main_menu
      end
      

    end

    appointment_strings = appointments.map {|appointment| "Tutor: #{appointment.tutor.name}, Appointment id: #{appointment.id}, Start Time: #{appointment.begin_datetime}, End Time: #{appointment.end_datetime}, Note: #{appointment.note}"}
    enumerate_options(appointment_strings)

    #present user options
    enumerate_options(['Cancel an appointment', 'Change appointment note', 'Home'])
    user_input = int_input(s = "\nPlease select an option:".yellow.bold, limits = [1, 3])

    if user_input == 1
      i = int_input(s = "\nPlease enter the number of the appointment you'd like to cancel:".yellow.bold, limits = [1, appointments.size])
      @student.cancel_appointment(appointments[i-1].id)
      puts "\nAppointment cancelled successfully!".green.bold
      sleep(1.5)
      view_upcoming_appointments_menu
    end

    if user_input == 2
      i = int_input(s = "\nPlease enter the number of the appointment you'd like to change:".yellow.bold, limits = [1, appointments.size])
      appointment = appointments[i-1]
      system 'clear'
      puts "\nPlease enter the new appointment note:".yellow.bold
      new_note = gets.chomp
      appointment.note = new_note
      appointment.save
      puts "\nAppointment note changed successfully!".green.bold 
      sleep(1.5)
      view_upcoming_appointments_menu
    end

    if user_input == 3
      main_menu
    end

    end

end