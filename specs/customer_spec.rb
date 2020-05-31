require('minitest/autorun')
require('minitest/reporters')
require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')
require_relative('../models/screening')

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class CustomerTest < MiniTest::Test

    def setup()
        Screening.delete_all()
        Customer.delete_all()
        Film.delete_all()
        Ticket.delete_all()

        @customer = Customer.new({ 'name' => 'James', 'funds' => 35 })
        @customer.save()

        @film = Film.new({ 'title' => 'ONWARD', 'price' => 10 })
        @film.save()

        @screening = Screening.new({ 'name' => 'Onward @ 10', 'show_time' => '10:00', 'capacity' => 2, 'film_id' => @film.id })
        @screening.save()

        @ticket = Ticket.new({ 'customer_id' => @customer.id, 'screening_id' => @screening.id })
        @ticket.save()
    end

    def test_CRUD()
        assert_equal([@customer], Customer.all())
        assert_equal(@customer, Customer.find(@customer.id))
        @customer.name = 'Joe'
        @customer.funds = 5
        @customer.update()
        assert_equal(@customer, Customer.find(@customer.id))
        @customer.delete()
        assert_nil(Customer.find(@customer.id))
    end

    def test_buy_ticket()
        @customer.buy_ticket(Screening.find(@screening.id))
        customer = Customer.find(@customer.id)
        assert_equal(25, customer.funds)
        assert_equal(2, customer.tickets_count())
    end

    def test_buy_ticket__insufficient_capacity()
        @customer.buy_ticket(Screening.find(@screening.id))
        @customer.buy_ticket(Screening.find(@screening.id))
        customer = Customer.find(@customer.id)
        assert_equal(25, customer.funds)
        assert_equal(2, customer.tickets_count())
    end

    def test_buy_ticket__insufficient_funds()
        @customer.funds = 5
        @customer.update()
        @customer.buy_ticket(Screening.find(@screening.id))
        customer = Customer.find(@customer.id)
        assert_equal(5, customer.funds)
        assert_equal(1, customer.tickets_count())
    end

    def test_tickets_count()
        result = Customer.find(@customer.id).tickets_count()
        assert_equal(1, result)
    end

end