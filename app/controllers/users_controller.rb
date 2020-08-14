class UsersController < ApplicationController


	get '/login' do 
		if Helpers.is_logged_in?(session)
			redirect "/tweets"
		end
		erb :'users/login'
	end

	post '/login' do 
		@user = User.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id 
			redirect to "/tweets"
		else
			redirect to "/login"
		end
	end

	get '/signup' do 
		if Helpers.is_logged_in?(session)
			redirect "/tweets"
		else
			erb :'users/create_user'
		end
	end

	post '/signup' do 
		if params[:username] == "" || params[:email] == "" || params[:password] == ""
			redirect "/signup"
		else
			@user = User.create(params)
			session[:user_id] = @user.id
			redirect '/tweets'
		end
	end

	get '/users/:slug' do 
		@user = User.find_by_slug(params[:slug])
		if !@user.nil?
			erb :'/users/show'
		else
			redirect to '/login'
		end
		# "HELLOOOOO"
	end


	get '/logout' do 
		if Helpers.is_logged_in?(session)
			session.clear
		# else
		# 	redirect to '/'
		end
		redirect to '/login'
	end


end
