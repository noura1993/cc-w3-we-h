require_relative('../db/sql_runner')

class Screening     

    attr_reader :id
    attr_accessor :name, :show_time, :capacity, :film_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @show_time = options['show_time']
        @capacity = options['capacity'].to_i
        @film_id = options['film_id'].to_i
    end

    def save()
        sql = "INSERT INTO screenings (name, show_time, capacity, film_id) VALUES ($1, $2, $3, $4) RETURNING id;"
        values = [@name, @show_time, @capacity, @film_id]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
    end

    def update()
        sql = "UPDATE screenings SET name = $1, show_time = $2, capacity = $3, film_id = $4 WHERE id = $5;"
        values = [@name, @show_time, @capacity, @film_id, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM screenings WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def ==(other)
        self.name == other.name && self.show_time == other.show_time &&
        self.capacity == other.capacity && self.film_id == other.film_id
    end

    def self.increase_screening_capacity(screening_id)
        screening = Screening.find(screening_id) 
        screening.capacity += 1
        screening.update()
    end

    def self.delete_all()
        sql = "DELETE FROM screenings;"
        SqlRunner.run(sql)
    end

    def self.find(id)
        sql = 'SELECT * FROM screenings WHERE id = $1;'
        values = [id]
        screening_record = SqlRunner.run(sql, values).first()
        return nil if screening_record == nil
        return Screening.new(screening_record)
    end

    def self.map(screening_data)
        return screening_data.map{ |screening| Screening.new(screening) } 
    end

    def self.all()
        sql = "SELECT * FROM screenings;"
        screenings = SqlRunner.run(sql)
        return Screening.map(screenings)
    end

end