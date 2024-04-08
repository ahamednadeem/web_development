require 'sinatra'  #framework for web application (receiving http requests)
require 'json'

class UserManagement
	def initialize
    		puts "Initialization complete"
    		@users = []   # array to store the users data
  	end

  	# Function to add user in the array
  	def add_user(user_info)
  		puts user_info
  		# checks if all necessary details are given
    		if user_info['name'].empty? || user_info['email'].empty? || user_info['mobile_number'].empty?
      			return { error: 'Invalid user information. Name, email, and mobile number are required.' }
    		end
    		
		# appending user data in the array
    		@users << user_info   
    		{ message: 'User added successfully', user_info: user_info }
  	end

  	# Function to update the user information based on the given email id
  	def update_user(user_info)
  		# we iterate through the array and find the matching email
    		user = @users.find { |u| u['email'] == user_info['email'] }
    		if user.nil?
      			return { error: 'No User found with the given email..Please Try again.' }
    		end
    	
		# merge is used to overwrite the data with the new data
    		user.merge!(user_info)
    		{ message: 'User updated successfully', user_info: user }
  	end

  	# Function to delete the user based on the email id provided
  	def delete_user(user_info)
  		# we iterate through the array and find the matching email
    		user = @users.find { |u| u['email'] == user_info['email'] }
    		if user.nil?
      			return { error: 'No user found with the given email...cannot delete...Try Again' }
    		end

    		@users.delete(user)
    		{ message: 'User deleted successfully', user_info: user }
  	end

  	# Function to list all users
  	def list_users
    		{ users: @users }
  	end
end

user_management = UserManagement.new  # object creation for class UserManagement

# Route for adding an user
post '/user/add' do
	content_type :json
  	begin
    		user_info = JSON.parse(request.body.read)
    		user_management.add_user(user_info).to_json
    		
    		# error handling
  		rescue JSON::ParserError  # when the request is not in json format
    			status 400  # bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # internal server error
    			{ error: e.message }.to_json
  	end
end

# Route for updating an user
post '/user/update' do
	content_type :json
  	begin
    		user_info = JSON.parse(request.body.read)
    		user_management.update_user(user_info).to_json
    		
    		# error handling
  		rescue JSON::ParserError # when the request is not in json format
    			status 400  # bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # internal server error
    			{ error: e.message }.to_json
  	end
end


# Route for deleting an user
post '/user/delete' do
	content_type :json
  	begin
    		user_info = JSON.parse(request.body.read)
    		user_management.delete_user(user_info).to_json
    		
    		# error handling
  		rescue JSON::ParserError
    			status 400  # bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # internal server error
    			{ error: e.message }.to_json
  	end
end

# Route for listing all users
get '/user/list' do
	content_type :json
	begin
  		user_management.list_users.to_json
  		
  		# error handling
  		rescue JSON::ParserError
    			status 400  # bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # internal server error
    			{ error: e.message }.to_json
    	end
end
