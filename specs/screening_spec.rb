require('minitest/autorun')
require('minitest/reporters')
require_relative('../models/screening')
require_relative('../models/film')

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ScreeningTest < MiniTest::Test

    def setup()
        Screening.delete_all()

        @film = Film.new({ 'title' => 'Onward', 'price' => 10 })
        @film.save()

        @screening = Screening.new({ 'name' => 'Onward @ 10', 'show_time' => '10:00', 'capacity' => 50, 'film_id' => @film.id })
        @screening.save()

    end

    def test_CRUD()
        assert_equal([@screening], Screening.all())
        assert_equal(@screening, Screening.find(@screening.id))
        @screening.name = 'Onward @ 6'
        @screening.show_time = '06:00'
        @screening.capacity = 70
        @screening.update()
        assert_equal(@screening, Screening.find(@screening.id))
        @screening.delete()
        assert_nil(Screening.find(@screening.id))
    end

end
