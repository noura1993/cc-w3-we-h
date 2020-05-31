require_relative('../db/sql_runner')
require_relative('./film')

class Customer 

    attr_reader :id
    attr_accessor :name, :funds

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @funds = options['funds'].to_i
    end

    def buy_ticket(screening)
        film = Film.find(screening.film_id)
        return if screening.capacity == 0 
        return if @funds < film.price
        @funds -= film.price
        update()
        new_ticket = Ticket.new({'customer_id' => @id, 'screening_id' => screening.id})
        new_ticket.save()
    end

    def tickets_count()
        return films().count()
    end

    def films()
        sql = "SELECT films.* 
        FROM films
        INNER JOIN screenings
        ON films.id = screenings.film_id
        INNER JOIN tickets 
        ON screenings.id = tickets.screening_id
        WHERE customer_id = $1;"
        values = [@id]
        films_records = SqlRunner.run(sql, values)
        return Film.map(films_records)
    end

    def save()
        sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id;"
        values = [@name, @funds]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
    end

    def update()
        sql = "UPDATE customers SET name = $1, funds = $2 WHERE id = $3;"
        values = [@name, @funds, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM customers WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def ==(other)
        self.name == other.name && self.funds == other.funds
    end

    def self.delete_all()
        sql = "DELETE FROM customers;"
        SqlRunner.run(sql)
    end

    def self.find(id)
        sql = 'SELECT * FROM customers WHERE id = $1;'
        values = [id]
        customer_record = SqlRunner.run(sql, values).first()
        return nil if customer_record == nil
        return Customer.new(customer_record)
    end

    def self.map(customer_data)
        return customer_data.map{ |customer| Customer.new(customer) }
    end

    def self.all()
        sql = "SELECT * FROM customers;"
        customers = SqlRunner.run(sql)
        return Customer.map(customers)
    end

end