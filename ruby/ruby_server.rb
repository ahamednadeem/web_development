require 'sinatra'  # Framework for web application (receiving HTTP requests)
require 'json'

class UserManagement
	def initialize
    		load_data
    		puts "Initialization complete"
  	end

  	# Function to load user data from file
  	def load_data
    		if File.exist?('data.txt')
      			file = File.read('data.txt')
      			@users = JSON.parse(file)
    		else  
    			# if no text file for storing data this array is used
      			@users = []  
    		end
  	end

  	# Function to save user data to file
  	def save_data
    		File.open('data.txt', 'w') do |f|
      			f.write(JSON.pretty_generate(@users))
    		end
  	end

  	# Function to add user in the array and save to file
  	def add_user(user_info)
    		# checks if all necessary details are given
    		if user_info['name'].empty? || user_info['email'].empty? || user_info['mobile_number'].empty?
      			return { error: 'Invalid user information. Name, email, and mobile number are required.' }
    		end
    		
    		# make sures no duplicate values for email or mobile number is entered
    		user = @users.find { |u| u['email'] == user_info['email'] || u['mobile_number'] == user_info['mobile_number'] }
    		if !user.nil?
    			return { error: 'No duplicate values allowed.'}
    		end
    
    		# append users data in users list
    		@users << user_info  # append users data in users list
    		save_data  
    		{ message: 'User added successfully', user_info: user_info }
  	end

  	# Function to update user information based on the given email id and save to file
  	def update_user(user_info)
    		# we iterate through the array and find the matching email
    		user = @users.find { |u| u['email'] == user_info['email'] }
    		if user.nil?
      			return { error: 'No User found with the given email. Please try again.' }
    		end
    
    		# merge is used to overwrite the data with the new data
    		user.merge!(user_info)
    		save_data
    		{ message: 'User updated successfully', user_info: user }
  	end

  	# Function to delete the user based on the email id provided and save to file
  	def delete_user(user_info)
  		# we iterate through the array and find the matching email
    		user = @users.find { |u| u['email'] == user_info['email'] }
    		if user.nil?
      			return { error: 'No user found with the given email. Cannot delete. Try again.' }
    		end

    		@users.delete(user)
    		save_data
    		{ message: 'User deleted successfully', user_info: user }
  	end

  	# Function to list all users
  	def list_users
    		{ users: @users }
  	end
end

user_management = UserManagement.new  # Object creation for class UserManagement

# Route for adding a user
post '/user/add' do
	content_type :json
  	begin
    		user_info = JSON.parse(request.body.read)
    		user_management.add_user(user_info).to_json
    
  		rescue JSON::ParserError # When the request is not in JSON format
    			status 400  # Bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # Internal server error
    			{ error: e.message }.to_json
  	end
end

# Route for updating a user
post '/user/update' do
	content_type :json
  	begin
    		user_info = JSON.parse(request.body.read)
    		user_management.update_user(user_info).to_json
    
  		rescue JSON::ParserError # When the request is not in JSON format
    			status 400  # Bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # Internal server error
    			{ error: e.message }.to_json
  	end
end

# Route for deleting a user
post '/user/delete' do
	content_type :json
  	begin
    		user_info = JSON.parse(request.body.read)
    		user_management.delete_user(user_info).to_json
    
  		rescue JSON::ParserError # When the request is not in JSON format
    			status 400  # Bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # Internal server error
    			{ error: e.message }.to_json
  	end
end

# Route for listing all users
get '/user/list' do
  	content_type :json
  	begin
    		user_management.list_users.to_json
    
  		rescue JSON::ParserError # When the request is not in JSON format
    			status 400  # Bad request
    			{ error: 'Invalid JSON format' }.to_json
  		rescue StandardError => e
    			status 500  # Internal server error
    			{ error: e.message }.to_json
  	end
end

