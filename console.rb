require('pry')
require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')

customer1 = Customer.new({ 'name' => 'James', 'funds' => 35 })
customer1.save()

customer2 = Customer.new({ 'name' => 'Anne', 'funds' => 60 })
customer2.save()

customer3 = Customer.new({ 'name' => 'Robert', 'funds' => 100 })
customer3.save()

film1 = Film.new({ 'title' => 'ONWARD', 'price' => 10 })
film1.save()

film2 = Film.new({ 'title' => 'MULAN', 'price' => 12 })
film2.save()

film3 = Film.new({ 'title' => 'MINIONS 2: THE RISE OF GRU', 'price' => 15 })
film3.save()

ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film2.id })
ticket1.save()

ticket2 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film3.id })
ticket2.save()

ticket3 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film1.id })
ticket3.save()

binding.pry

nil
