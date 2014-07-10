json.cache! @photo do
	json.name @photo.name
	json.id @photo.id
	json.image do
		json.url @photo.image.url
	end
end