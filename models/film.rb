require_relative('../db/sql_runner')

class Film 

    attr_reader :id
    attr_accessor :title, :price

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @title = options['title']
        @price = options['price'].to_i
    end

    def save()
        sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id;"
        values = [@title, @price]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
    end

    def update()
        sql = "UPDATE films SET title = $1, price = $2 WHERE id = $3;"
        values = [@title, @price, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM films WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.delete_all()
        sql = "DELETE FROM films;"
        SqlRunner.run(sql)
    end

    def self.find(id)
        sql = 'SELECT * FROM films WHERE id = $1;'
        values = [id]
        film_hash = SqlRunner.run(sql, values).first()
        return nil if film_hash == nil
        return Film.new(film_hash)
    end

    def self.map(film_data)
        return film_data.map{ |film| Film.new(film)}
    end

    def self.all()
        sql = "SELECT * FROM films "
        films = SqlRunner.run(sql)
        return Film.map(films)
    end

end