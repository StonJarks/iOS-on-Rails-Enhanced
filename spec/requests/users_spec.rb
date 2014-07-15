require "spec_helper"

# User account specs

describe "POST v1/users/" do
	it "creates a new user" do
		
		expect{
			post "/v1/users", {
			email: "user@example,com",
			password: "foobar"
		}.to_json, { 'Content-Type' => 'application/json'}
		}.to change(User, :count).by(1)

		expect(response.code.to_i).to eq 200
	end
end

describe 'PATCH /v1/users/.:id' do
	before(:each) do
		@user = create(:user)
		post "/v1/auth/login", { email: @user.email, password: "secret"}.to_json, { 'Content-Type' => 'application/json'}
		@auth_token = @user.auth_token
		#login_user_post(@user.email, 'secret')
	end

	it "changes the users credentials" do
		patch "/v1/users/#{@user.id}", {
			email: "newmail@example.com",
			password: "newsecret",
			auth_token: @auth_token
		}.to_json, { 'Content-Type' => 'application/json'}

		@user.reload
		expect(@user.email).to eq "newmail@example.com"
		expect(response_json).to eq({"id" => @user.id})
	end

	it "returns an error message when invalid" do
		patch "/v1/users/#{@user.id}", {
			password: "secret",
			auth_token: @auth_token
		}.to_json, { 'Content-Type' => 'application/json'}

		@user.reload

		expect(@user.email).not_to be nil
		expect(response_json).to eq({
			'message' => 'Validation Failed',
			'errors' => [ "Email can't be blank"]
			})

		expect(response.code.to_i).to eq 422
	end
end

describe "DELETE /v1/users/:id" do
	before(:each) do
		@user = create(:user)
		post "/v1/auth/login", { email: @user.email, password: "secret"}.to_json, { 'Content-Type' => 'application/json'}
		@auth_token = @user.auth_token
		#login_user_post(@user.email, 'secret')
	end
	
	it "deletes the users account" do
		expect{
			delete "/v1/users/#{@user.id}", { auth_token: @auth_token }.to_json, { 'Content-Type' => 'application/json'}
			}.to change(User, :count).by(-1)
		
		expect(response.code.to_i).to eq 200
	end
end

# User log in specs

describe "POST /v1/auth/login" do
	it "logs in the user" do
	@user = create(:user)
	post "/v1/auth/login", { email: @user.email, password: "secret"}.to_json, { 'Content-Type' => 'application/json'}
	
	expect(response.code.to_i).to eq 200
	expect(response_json).to eq({
		'email' => @user.email,
		'auth_token' => @user.auth_token,
		'auth_token_expires_at' => @user.auth_token_expires_at.to_json
		})
	end
end
