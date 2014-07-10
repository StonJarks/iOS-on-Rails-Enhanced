json.cache! @photos do
	json.id photo.id
	json.name photo.name
	json.image do
		json.url photo.image.thumb.url
	end
end