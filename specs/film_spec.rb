require('minitest/autorun')
require('minitest/reporters')
require_relative('../models/film')
require_relative('../models/customer')
require_relative('../models/ticket')

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class FilmTest < MiniTest::Test

    def setup()
        Film.delete_all()
        Customer.delete_all()
        Ticket.delete_all()

        @customer1 = Customer.new({ 'name' => 'James', 'funds' => 35 })
        @customer1.save()
        @customer2 = Customer.new({ 'name' => 'Anne', 'funds' => 60 })
        @customer2.save()


        @film = Film.new({ 'title' => 'Onward', 'price' => 10 })
        @film.save()

        @ticket1 = Ticket.new({ 'customer_id' => @customer1.id, 'film_id' => @film.id })
        @ticket1.save()
        @ticket2 = Ticket.new({ 'customer_id' => @customer2.id, 'film_id' => @film.id })
        @ticket2.save()
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

end
