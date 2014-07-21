require "spec_helper"

describe "GET /events/:id/photos" do
	it "returns all photos of an event" do
		event = create(:event)
		photo = create(:photo, event: event)
		photo2 = create(:photo, event: event)

		get "/events/#{event.id}/photos", {}, set_headers
		expect(response_json).to eq(
			[
				{
					"name" => photo.name,
					"id" => photo.id,
					"image" => {"url" => photo.image.thumb.url}
				},
				{
					"name" => photo2.name,
					"id" => photo2.id,
					"image" => { "url" => photo2.image.thumb.url}
				}
			]
		)
	end
end

describe "GET /events/:id/photos/:id" do
	it "returns a photo" do
		event = create(:event)
		photo = create(:photo, event: event)

		get "events/#{event.id}/photos/#{photo.id}", {}, set_headers
		expect(response_json).to eq(
			{
				"name" => photo.name,
				"id" => photo.id,
				"image" => { "url" => photo.image.url }
			}
		)
	end
end

describe "POST /events/:id/photo" do
	it "saves the name and photo" do
		event = create(:event)
		test_photo = Base64.strict_encode64(open(File.new("#{Rails.root}/spec/support/fixtures/image.jpg")) {|io| io.read  })

		expect{ post "/events/#{event.id}/photos", {
						name: "photo name",
						event: { event: event },
						image: test_photo 
				}.to_json, set_headers

				}.to change(Photo, :count).by(1)
		 event = Event.last
		 photo = Photo.last
		 expect(response_json).to eq({'id' => photo.id})
		 expect(photo.name).to eq "photo name"
		 expect(photo.event).to eq event
	end
 	it "returns an error message when invalid" do
 		event = create(:event)

 		expect{ post "/events/#{event.id}/photos",
				{}.to_json,	set_headers
			}.to_not change(Photo, :count)

		expect(response_json).to eq({
			'message' => 'Validation Failed',
			'errors' => [
				"Image can't be blank"
				]
			})
		expect(response.code.to_i).to eq 422
	end
end