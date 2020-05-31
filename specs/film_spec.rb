require('minitest/autorun')
require('minitest/reporters')
require_relative('../models/film')
require_relative('../models/customer')
require_relative('../models/ticket')
require_relative('../models/screening')

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class FilmTest < MiniTest::Test

    def setup()
        Screening.delete_all()
        Film.delete_all()
        Customer.delete_all()
        Ticket.delete_all()

        @customer1 = Customer.new({ 'name' => 'James', 'funds' => 35 })
        @customer1.save()
        @customer2 = Customer.new({ 'name' => 'Anne', 'funds' => 60 })
        @customer2.save()


        @film = Film.new({ 'title' => 'Onward', 'price' => 10 })
        @film.save()

        @screening1 = Screening.new({ 'name' => 'Onward @ 10', 'show_time' => '10:00', 'capacity' => 50, 'film_id' => @film.id })
        @screening1.save()
        @screening2 = Screening.new({ 'name' => 'Onward @ 12', 'show_time' => '12:00', 'capacity' => 100, 'film_id' => @film.id })
        @screening2.save()
        @screening3 = Screening.new({ 'name' => 'Onward @ 14', 'show_time' => '14:00', 'capacity' => 100, 'film_id' => @film.id })
        @screening3.save()

        @ticket1 = Ticket.new({ 'customer_id' => @customer1.id, 'screening_id' => @screening1.id })
        @ticket1.save()
        @ticket2 = Ticket.new({ 'customer_id' => @customer1.id, 'screening_id' => @screening2.id })
        @ticket2.save()
        @ticket3 = Ticket.new({ 'customer_id' => @customer2.id, 'screening_id' => @screening2.id })
        @ticket3.save()
        @ticket4 = Ticket.new({ 'customer_id' => @customer2.id, 'screening_id' => @screening3.id })
        @ticket4.save()
    end

    def test_CRUD()
        assert_equal([@film], Film.all())
        assert_equal(@film, Film.find(@film.id))
        @film.title = 'Avengers'
        @film.price = 5
        @film.update()
        assert_equal(@film, Film.find(@film.id))
        @film.delete()
        assert_nil(Film.find(@film.id))
    end

    def test_customers_count()
        result = Film.find(@film.id).customers_count()
        assert_equal(2, result)
    end

    def test_most_popular_time()
        result = @film.most_popular_time()
    end

end
