require_relative('../db/sql_runner')

class Film 

    attr_reader :id
    attr_accessor :title, :price

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @title = options['title']
        @price = options['price'].to_i
    end

    def customers_count()
        return customers().count()
    end

    def customers()
        sql = "
        SELECT customers.* 
        FROM customers 
        INNER JOIN tickets 
        ON customers.id = tickets.customer_id 
        WHERE film_id = $1;"
        values = [@id]
        customers_records = SqlRunner.run(sql, values)
        return Customer.map(customers_records)
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

    def ==(other)
        self.title == other.title && self.price == other.price
    end

    def self.delete_all()
        sql = "DELETE FROM films;"
        SqlRunner.run(sql)
    end

    def self.find(id)
        sql = 'SELECT * FROM films WHERE id = $1;'
        values = [id]
        film_record= SqlRunner.run(sql, values).first()
        return nil if film_record == nil
        return Film.new(film_record)
    end

    def self.map(film_data)
        return film_data.map{ |film| Film.new(film) }
    end

    def self.all()
        sql = "SELECT * FROM films;"
        films = SqlRunner.run(sql)
        return Film.map(films)
    end

end