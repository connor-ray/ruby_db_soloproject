require 'sqlite3'
require 'faker'

data = SQLite3::Database.new("coffeedata.db")
data.results_as_hash = true

make_coffee_table = <<-SQL
  CREATE TABLE IF NOT EXISTS coffee (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    good_customer BOOLEAN,
    roast VARCHAR(255)
  )
SQL

data.execute(make_coffee_table)

def add_customers (data, name, good_customer, roast)
  data.execute('INSERT INTO coffee (name, good_customer, roast) VALUES (?, ?, ?)', [name, good_customer, roast])
end

puts 'Welcome to the CoffeeBot 3000!'
puts 'This program allows you to create a database of your all your coffee customers!'
puts 'You will be able to log their name, favortie roast and if they are a good customer.'
puts 'Also, if you want to have some fun we can generate some fake customers for you.'
puts 'First off, will you be adding your own customers or would you like us to generate them for you?'
loop do
  puts <<-RUBY
Please type 'my own' to add your own customers, or type 'random' for us to generate them for you.
  RUBY
  customer_inputs = gets.chomp

  if customer_inputs == 'my own'
    puts "Awesome!"
    puts 'How many customers will you be adding?'
    amount_of_customers = gets.to_i
    amount_of_customers.times do
      puts 'For each customer please type their name(First Last), roast(dark, medium, light) and if they are a good customer(yes/no).'
      puts 'Example: John Hancock, light, yes'
      customer_data = gets.chomp.split(/\s*,\s*/)
      customer_name = customer_data[0]
      customer_roast = customer_data[1]
      is_good_customer = customer_data[2]
        if is_good_customer == 'yes'
          is_good_customer = 1
        elsif is_good_customer == 'no'
          is_good_customer = 0
        end
      add_customers(data, customer_name, is_good_customer, customer_roast)
      break
    end
  elsif customer_inputs == 'random'
    puts 'Great! This will be fun'
    puts 'How many customers would you like to create?'
    amount_of_customers = gets.to_i
    amount_of_customers.times do

      add_customers(data, Faker::Name.name, rand(0..1), ['dark', 'medium', 'light'].sample)
    end
    break
  else
    puts 'Oops, I think you made a typo!'
  end
end

coffee_data =  data.execute('SELECT * FROM coffee')

coffee_data.each do |customer|
  if customer['good_customer'] == 0
  puts "*BAD CUSTOMER* #{customer['name']} likes a #{customer['roast']} roast."
  elsif customer['good_customer'] == 1
  puts "*GOOD CUSTOMER* #{customer['name']} likes a #{customer['roast']} roast."
  end
  puts '--'
end
