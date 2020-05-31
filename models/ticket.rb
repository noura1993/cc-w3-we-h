require_relative('../db/sql_runner')
require_relative('./screening')

class Ticket     

    attr_reader :id
    attr_accessor :customer_id, :screening_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @customer_id = options['customer_id'].to_i 
        @screening_id = options['screening_id'].to_i
    end

    def save()
        sql = "INSERT INTO tickets (customer_id, screening_id) VALUES ($1, $2) RETURNING id;"
        values = [@customer_id, @screening_id]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
        screening = Screening.find(@screening_id)
        screening.capacity -= 1
        screening.update()
    end

    def delete()
        sql = "DELETE FROM tickets WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
        Screening.increase_screening_capacity(@screening_id)   
    end

    def ==(other)
        self.customer_id == other.customer_id && self.screening_id == other.screening_id
    end

    def self.delete_all()
        sql = "DELETE FROM tickets RETURNING screening_id;"
        screenings_id = SqlRunner.run(sql)
        screenings_id.each{ |screening_id| Screening.increase_screening_capacity(screening_id) }
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