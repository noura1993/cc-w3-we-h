require_relative('../db/sql_runner')

class Customer 

    attr_reader :id
    attr_accessor :name, :funds

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @funds = options['funds'].to_i
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

    def self.delete_all()
        sql = "DELETE FROM customers;"
        SqlRunner.run(sql)
    end

    def self.find(id)
        sql = 'SELECT * FROM customers WHERE id = $1;'
        values = [id]
        customer_hash = SqlRunner.run(sql, values).first()
        return nil if customer_hash == nil
        return Customer.new(customer_hash)
    end

    def self.map(customer_data)
        return customer_data.map{ |customer| Customer.new(customer)}
    end

    def self.all()
        sql = "SELECT * FROM customers "
        customers = SqlRunner.run(sql)
        return Customer.map(customers)
    end

end