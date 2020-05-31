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
        INNER JOIN screenings 
        ON tickets.screening_id = screenings.id
        WHERE film_id = $1;"
        values = [@id]
        customers_records = SqlRunner.run(sql, values)
        customers = Customer.map(customers_records)
        unique_customers = []
        customers.each{ |customer| unique_customers.push(customer) if !unique_customers.include?(customer)}
        return unique_customers
    end

    def most_popular_time()
        sql = "SELECT screenings.show_time
        FROM tickets
        INNER JOIN screenings
        ON tickets.screening_id = screenings.id
        WHERE film_id = $1;"
        values = [@id]
        show_time_records = SqlRunner.run(sql, values)
        show_time_tickets = Hash.new()
        show_time_records.each do |show_time_record| 
            if(!show_time_tickets.include?(show_time_record))
                show_time_tickets[show_time_record] = 1
            else
                show_time_tickets[show_time_record] += 1
            end
        end
        return nil if show_time_tickets.empty?
        return show_time_tickets.max_by{|k,v| v}.first()['show_time']
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