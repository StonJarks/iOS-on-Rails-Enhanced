class Api::V1::PhotosController < ApiController
	respond_to :json

	api :GET, "/events/:id/photos", "lists all photos of a specific event"
	param :event_id, :number
	example " [{'name': 'image1', 'id': '1', 'image':{'url': 'http://example.com/image1_thumb.jpg'}, {'name': 'image2', 'id': '2', 'image':{'url': 'http://example.com/image2_thumb.jpg'}]"
	def index
		@event = Event.find(params[:event_id])
		@photos = @event.photos.all
	end

	api :GET, "/events/:id/photos/:id", "shows a specific photo"
	param :photo, Hash do
		param :id, :number
		param :name, String
		param :image, Hash do
			param :url, String
		end
	end
	example "{ 'id': '1', 'name':'test', 'image':{ 'url': 'http://example.com/test.jpg'}"
	def show
		@event = Event.find(params[:event_id])
		@photo = @event.photos.find(params[:id])
	end

	api :POST, "/events/:id/photos", "creates a new photo"
	error :code => 422, :desc => "Unprocessable entries"
	param :photo, Hash do
		param :name, String
		param :event_id, :number
		param :image, String, desc: "Base64 encoded jpg image"
	end
	example " { 'name': 'MyPicture', 'event': { 'id': '1'}, 'image' : '1234keijfkiejdke2929kjdfjfDKE22'"
	def create
		@event = Event.find(params[:event_id])
		if params[:image]
			tempfile = Tempfile.new("fileupload")
			begin
				tempfile.binmode
				tempfile.write(Base64.decode64(params[:image]))
				filename = "#{params[:name].gsub(/\s+/, "").downcase}.jpg"
				uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => filename, :original_filename => "file")
				
				@photo = @event.photos.build(name: params[:name], image: uploaded_file)
			
			ensure
				tempfile.close
				tempfile.unlink
			end
		else
			@photo = @event.photos.build(params[:name])
		end
		
		if @photo.save
			render
		else
			render json: {
		   		message: 'Validation Failed',
		   		errors: @photo.errors.full_messages
			}, status: 422	
		end
	end

	# private

	#   def photo_params
	#     {
	#       event: params[:id],
	#       name: params[:name],
	#       image: params[:image]
	#   	}
	#   end
end