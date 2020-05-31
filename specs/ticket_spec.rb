require('minitest/autorun')
require('minitest/reporters')
require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')
require_relative('../models/screening')

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class TicketTest < MiniTest::Test

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

    def test_CRD()
        assert_equal([@ticket], Ticket.all())
        assert_equal(@ticket, Ticket.find(@ticket.id))
        assert_equal(1, Screening.find(@screening.id).capacity)
        @ticket.delete()
        assert_equal(2, Screening.find(@screening.id).capacity)
        assert_nil(Ticket.find(@ticket.id))
    end

end