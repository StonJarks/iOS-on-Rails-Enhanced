class Api::V1::PhotosController < ApiController
	respond_to :json

	def index
		@event = Event.find(params[:event_id])
		@photos = @event.photos.all
	end

	def show
		@event = Event.find(params[:event_id])
		@photo = @event.photos.find(params[:id])
	end

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