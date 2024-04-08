# RUBY server to handle HTTP request and do the functions present in th http body.

require 'sinatra'  #framework for web application (received http requests)
require 'json'

class UserManagement
	def initialize
		puts "Initalization complete"
  		@users = []
	end

  	def add_user(user_info)  # function to add user in the array
    		if user_info['name'].nil? || user_info['email'].nil? || user_info['mobile_number'].nil?  # checks if all necessary details are given
      			return { error: 'Invalid user information. Name, email, and mobile number are required.' }
    		end

    		@users << user_info  # appends the user info in the array
    		{ message: 'User added successfully', user_info: user_info }
  	end

  	def update_user(user_info)  # function to update the user information based on the given email id
    		user = @users.find { |u| u['email'] == user_info['email'] }  # we iterate through the array and find the matching email
    		if user.nil?
      			return { error: 'No User found with the given email..Please Try again.' }
    		end

    		user.merge!(user_info)  # merge is used to overwrite the data with the new data
    		{ message: 'User updated successfully', user_info: user }
  	end

  	def delete_user(user_info)  # function to delete the user based on the email id provided
    		user = @users.find { |u| u['email'] == user_info['email'] } # we iterate through the array and find the matching email

    		if user.nil?
      			return { error: 'No user found with the given email...cannot delete...Try Again' }
   		end

    		@users.delete(user)
    		{ message: 'User deleted successfully', user_info: user }
  	end

  	def list_users  # function to just list the users 
    		{ users: @users }
  	end
end

user_management = UserManagement.new  # object creation for class UserManagement

post '/user/add' do   # the http request is received here for adding an user
	content_type :json
  	user_info = JSON.parse(request.body.read)
  	#puts user_info
  	user_management.add_user(user_info).to_json
end
  
post '/user/update' do  # the http request is received here for updating an user's details
  	content_type :json
  	user_info = JSON.parse(request.body.read)
  	#puts user_info
  	user_management.update_user(user_info).to_json
end

post '/user/delete' do  # the http request is received here for deleting an user
  	content_type :json
  	user_info = JSON.parse(request.body.read)
  	#puts user_info
  	user_management.delete_user(user_info).to_json
end

get '/user/list' do  # the http request is received here for listing the user details
  	content_type :json
  	user_management.list_users.to_json
end
