require 'httparty'
require 'json'

class UserClient
	def add_user  # function to add user, convert it to json format and sent it as a http request
    		puts "Enter user's name:"  
    		name = gets.chomp  # removes the whitespaces to the right of the name

    		puts "Enter user's email:"
   		email = gets.chomp # removes the whitespaces to the right of the email

    		puts "Enter user's mobile number:"
    		mobile_number = gets.chomp   # removes the whitespaces to the right of the number

    		response = HTTParty.post('http://localhost:4567/user/add',
                             body: { name: name, email: email, mobile_number: mobile_number }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    		puts JSON.parse(response.body)  # the response from the server is printed
  	end

  	def list_users   # function to list users, convert it to json format and sent it as a http request
    		response = HTTParty.get('http://localhost:4567/user/list')
    		puts JSON.parse(response.body)
  	end

  	def update_user  # function to update user, convert it to json format and sent it as a http request
    		puts "Enter user's email to update:"
    		email = gets.chomp # removes the whitespaces to the right of the email

    		puts "Enter updated name:"
    		name = gets.chomp  # removes the whitespaces to the right of the name

    		puts "Enter updated mobile number:"
    		mobile_number = gets.chomp

    		response = HTTParty.post('http://localhost:4567/user/update',
                             body: { email: email, name: name, mobile_number: mobile_number }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    		puts JSON.parse(response.body)
  	end

  	def delete_user
    		puts "Enter user's email to delete:"
    		email = gets.chomp   # removes the whitespaces to the right of the email

    		response = HTTParty.post('http://localhost:4567/user/delete',
                             body: { email: email }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    		puts JSON.parse(response.body)
  	end

  	def start
    		loop do  # this is an infinite loop which gives options to add/delete/update/list users information 
	      		puts "\nSelect an option: (Enter in numbers listed)"
	      		puts "1. Add an user"
	      		puts "2. List all the users"
	      		puts "3. Update an user"
	      		puts "4. Delete an user"
	      		puts "5. Exit"

	      		choice = gets.chomp.to_i

	      		case choice  
	      			when 1
					add_user
	      			when 2
					list_users
	      			when 3
					update_user
	      			when 4
					delete_user
	      			when 5
					puts "Exiting..."
					break
	      			else
					puts "Invalid choice. Please select again."
      			end
    		end
  	end
end

user_client = UserClient.new  # Object creation for class UserClient
user_client.start
