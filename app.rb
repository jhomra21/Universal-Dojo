require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"
require_relative "models.rb"

#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

get "/" do
	erb :index
end

get "/videos" do
	authenticate!
	@videos = Video.all(user_id: current_user.id)
	@tags = Tag.all
	@comments = Comment.all
	erb :videos
end

get "/dashboard" do
	authenticate!
	erb :dashboard
end

post "/post/create" do      #grabs backend code in creating a new post
	authenticate!
	vid = Video.new
	
	if params["title"] && params["description"] && params["video_url"]
		vid.title = params["title"]
		vid.description = params["description"]
		vid.video_url = params["video_url"]
		vid.user_id = current_user.id
		vid.save

		#adding tags
		if params["tag_name"]
			t = params["tag_name"].split(",")
			t.each do |tags|
				ta = Tag.new
				ta.tag_name = tags
				ta.video_id = vid.id
				ta.save
			end
			
		end
		redirect "/videos"
	end 
	
end

#post "/tags" do
#	erb :tags
#end

get "/post/new" do       #erb to postVideo
	authenticate!
	erb :postVideo
end 

get "/post/:id/delete" do   #delete function
	authenticate!

	
		v=Video.get(params["id"])

		if v
			if v.user_id==current_user.id
				v.destroy
			else
				erb :noPermission
			end 

			redirect "/videos"

		else
			erb :videoDNE
		end 
end 

get "/post/:id/comment" do 	#adds comment
	authenticate!
	v = Video.get(params["id"])
	if params["text"]
		t = Comment.new
		t.user_id = current_user.id
		t.video_id = v.id
		t.text = params["text"]
		t.save
	end
	redirect "/videos"
end

get "/post/:id/comment/delete" do	#delete comment
	authenticate!



	redirect "/videos"
end

