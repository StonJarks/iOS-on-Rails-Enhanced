module RequestHeaders
	def set_headers(auth_token)
		{
			'Accept' => "application/json; version=1",
			'Content-Type' => 'application/json',
			'auth_token' => "#{auth_token}"
		}
	end
end