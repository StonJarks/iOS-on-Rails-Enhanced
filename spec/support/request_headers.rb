module RequestHeaders
	def set_headers
		{
			'Accept' => "application/json; version=1",
			'Content-Type' => 'application/json'
		}
	end
end