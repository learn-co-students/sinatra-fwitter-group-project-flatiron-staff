class TweetsController < ApplicationController


get '/tweets' do 
	if Helpers.is_logged_in?(session)
		@tweets = Tweet.all 
		erb :'tweets/tweets'
	else
		redirect to '/login'
	end
end

get '/tweets/new' do 
	if Helpers.is_logged_in?(session)
		erb :'/tweets/new'
	else
		redirect to '/login'
	end

end

post '/tweets' do 
	@user = Helpers.current_user(session)
	if @user.nil?
		redirect to '/login'
	elsif params[:content].empty?
		redirect to '/tweets/new'
	else
		@user.tweets.build({content: params[:content]})
		@user.save 
	end
	redirect to '/tweets'
end



get '/tweets/:id' do 
	if Helpers.is_logged_in?(session)
		@tweet = Tweet.find(params[:id])
		erb :'tweets/show_tweet'
	else
		redirect to '/login'
	end
end

get '/tweets/:id/edit' do
	if Helpers.is_logged_in?(session)
		@tweet = Tweet.find(params[:id])
		if Helpers.current_user(session).tweets.include?(@tweet)
			erb :'tweets/edit_tweet'
		else
			redirect to '/login'
		end
	else
		redirect to '/login'
	end
	# redirect to '/login'
end

patch '/tweets/:id' do 
	@tweet = Tweet.find(params[:id])
	if params[:content] == "" 
		redirect to "/tweets/#{@tweet.id}/edit"
	else
		@tweet.update(:content => params[:content])
		redirect to '/tweets'
	end
end

delete '/tweets/:id/delete' do 
	if Helpers.is_logged_in?(session)
		@tweet = Tweet.find(params[:id])
		if Helpers.current_user(session).tweets.include?(@tweet)
			@tweet.delete 
			redirect to '/tweets'
		else
			redirect to '/tweets'
		end
	else 
		redirect to '/login'
	end
end




end
