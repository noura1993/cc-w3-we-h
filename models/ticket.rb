require_relative('../db/sql_runner')

class Ticket     

    attr_reader :id
    attr_accessor :customer_id, :film_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @customer_id = options['customer_id'].to_i 
        @film_id = options['film_id'].to_i
    end

    def save()
        sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2) RETURNING id;"
        values = [@customer_id, @film_id]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
    end

    def update()
        sql = "UPDATE tickets SET customer_id = $1, film_id = $2 WHERE id = $3;"
        values = [@customer_id, @film_id, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM tickets WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.delete_all()
        sql = "DELETE FROM tickets;"
        SqlRunner.run(sql)
    end

    def self.find(id)
        sql = 'SELECT * FROM tickets WHERE id = $1;'
        values = [id]
        ticket_hash = SqlRunner.run(sql, values).first()
        return nil if ticket_hash == nil
        return Ticket.new(ticket_hash)
    end

    def self.map(ticket_data)
        return ticket_data.map{ |ticket| Ticket.new(ticket)}
    end

    def self.all()
        sql = "SELECT * FROM tickets "
        tickets = SqlRunner.run(sql)
        return tickets.map{ |ticket| Ticket.new(ticket)}
    end

end