require_relative('../db/sql_runner')

class Ticket     

    attr_reader :id
    attr_accessor :customer_id, :film_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @customer_id = options['customer_id'].to_i 
        @screening_id = options['screening_id'].to_i
    end

    def save()
        sql = "INSERT INTO tickets (customer_id, screening_id) VALUES ($1, $2) RETURNING id;"
        values = [@customer_id, @screening_id]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
    end

    def update()
        sql = "UPDATE tickets SET customer_id = $1, screening_id = $2 WHERE id = $3;"
        values = [@customer_id, @screening_id, @id]
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
        ticket_record = SqlRunner.run(sql, values).first()
        return nil if ticket_record == nil
        return Ticket.new(ticket_record)
    end

    def self.map(ticket_data)
        return ticket_data.map{ |ticket| Ticket.new(ticket) } 
    end

    def self.all()
        sql = "SELECT * FROM tickets;"
        tickets = SqlRunner.run(sql)
        return Ticket.map(tickets)
    end

end