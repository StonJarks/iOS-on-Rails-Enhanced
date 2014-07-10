require "spec_helper"

describe "GET /v1/events/:id/photos" do
	it "returns all photos of an event" do
		event = create(:event)
		photo = create(:photo, event: event)
		photo2 = create(:photo, event: event)

		get "/v1/events/#{event.id}/photos"
		expect(response_json).to eq(
			[
				{
					"name" => photo.name,
					"id" => photo.id,
					"image" => {"url" => photo.image.url}
				},
				{
					"name" => photo2.name,
					"id" => photo2.id,
					"image" => { "url" => photo2.image.url}
				}
			]
		)
	end
end

describe "GET /v1/events/:id/photos/:id" do
	it "returns a photo" do
		event = create(:event)
		photo = create(:photo, event: event)

		get "v1/events/#{event.id}/photos/#{photo.id}"
		expect(response_json).to eq(
			{
				"name" => photo.name,
				"id" => photo.id,
				"image" => { "url" => photo.image.url }
			}
		)
	end
end

describe "POST /v1/events/:id/photo" do
	it "saves the name and photo" do
		event = create(:event)
		test_photo = Base64.strict_encode64(open(File.new("#{Rails.root}/spec/support/fixtures/image.jpg")) {|io| io.read  })

		expect{ post "v1/events/#{event.id}/photos", {
						name: "photo name",
						event: { event: event },
						image: test_photo 
				}.to_json, { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

				}.to change(Photo, :count).by(1)
		 event = Event.last
		 photo = Photo.last
		 expect(response_json).to eq({'id' => photo.id})
		# expect()
		 expect(photo.name).to eq "photo name"
		 expect(photo.event).to eq event
		#expect(photo.image.filename).to eq "image.jpg"
		#expect(photo.image).to eq({ "url" => photo.image.url})
	end
# 	it "returns an error message when invalid"
end