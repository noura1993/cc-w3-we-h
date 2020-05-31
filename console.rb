require('pry')
require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')
require_relative('./models/screening')

Screening.delete_all()
Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({ 'name' => 'James', 'funds' => 35 })
customer1.save()

customer2 = Customer.new({ 'name' => 'Anne', 'funds' => 60 })
customer2.save()

customer3 = Customer.new({ 'name' => 'Robert', 'funds' => 100 })
customer3.save()



film1 = Film.new({ 'title' => 'Onward', 'price' => 10 })
film1.save()

film2 = Film.new({ 'title' => 'Mulan', 'price' => 12 })
film2.save()

film3 = Film.new({ 'title' => 'Minions', 'price' => 15 })
film3.save()



screening1 = Screening.new({ 'name' => 'Onward @ 10', 'show_time' => '10:00', 'capacity' => 50, 'film_id' => film1.id })
screening1.save()

screening2 = Screening.new({ 'name' => 'Mulan @ 12', 'show_time' => '12:00', 'capacity' => 30, 'film_id' => film2.id })
screening2.save()

screening3 = Screening.new({ 'name' => 'Mulan @ 8', 'show_time' => '08:00', 'capacity' => 100, 'film_id' => film2.id })
screening3.save()



ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'screening_id' => screening2.id })
ticket1.save()

ticket2 = Ticket.new({ 'customer_id' => customer2.id, 'screening_id' => screening2.id })
ticket2.save()

ticket3 = Ticket.new({ 'customer_id' => customer3.id, 'screening_id' => screening3.id })
ticket3.save()



binding.pry

nil
