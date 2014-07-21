require "spec_helper"

# User account specs

describe "POST /users/" do
	it "creates a new user" do
		
		expect{
			post "/users", {
			email: "user@example,com",
			password: "foobar"
		}.to_json, set_headers		
		}.to change(User, :count).by(1)

		expect(response.code.to_i).to eq 201
	end
end

describe 'PATCH /users/.:id' do
	context "as the user" do
		before(:each) do
			@user = create(:user)
	
			post "/auth/login", { email: @user.email, password: "secret"}.to_json, set_headers
			@auth_token = @user.auth_token
		end

		it "changes the users credentials" do

			patch "/users/#{@user.id}", {
				email: "newmail@example.com",
				password: "newsecret",
				auth_token: @auth_token
			}.to_json, set_headers

			@user.reload
			expect(@user.email).to eq "newmail@example.com"
			expect(response.code.to_i).to eq 200
			expect(response_json).to eq({"id" => @user.id})
		end

		it "returns an error message when invalid" do

			patch "/users/#{@user.id}", {
				password: "secret",
				auth_token: @auth_token
			}.to_json, set_headers
			@user.reload

			expect(@user.email).not_to be nil
			expect(response_json).to eq({
				'message' => 'Validation Failed',
				'errors' => [ "Email can't be blank"]
				})

			expect(response.code.to_i).to eq 422
		end
	end

	context "as another user" do
		before(:each) do
			@user = create(:user)
			@bad_user = create(:user)
			
			post "/auth/login", { email: @bad_user.email, password: "secret"}.to_json, set_headers
			@auth_token = @bad_user.auth_token
		end

		it "doesn't delete another users account" do
			patch "/users/#{@user.id}", {
				email: "newmail@example.com",
				password: "newsecret",
				auth_token: @auth_token
			}.to_json, set_headers
			@user.reload
			expect(@user.email).to_not eq "newmail@example.com"
			expect(response.code.to_i).to eq 403
		end
	end
end

describe "DELETE /users/:id" do
	context "as the user" do
		before(:each) do
			@user = create(:user)
		
			post "/auth/login", { email: @user.email, password: "secret"}.to_json, set_headers
			@auth_token = @user.auth_token
		end
		
		it "deletes the users account" do
			expect{
				delete "/users/#{@user.id}", { auth_token: @auth_token }.to_json, set_headers
				}.to change(User, :count).by(-1)
			
			expect(response.code.to_i).to eq 200
		end
	end

	context "as another user" do
		before(:each) do
			@user = create(:user)
			@bad_user = create(:user)
			
			post "/auth/login", { email: @bad_user.email, password: "secret"}.to_json, set_headers
			@auth_token = @bad_user.auth_token
		end

		it "doesn't delete another users account" do
			expect{
				delete "/users/#{@user.id}", { auth_token: @auth_token }.to_json, set_headers
				}.to_not change(User, :count).by(-1)
			
			expect(response.code.to_i).to eq 403
		end
	end
end

# User log in specs

describe "POST /auth/login" do
	it "logs in the user" do
	@user = create(:user)

	post "/auth/login", { email: @user.email, password: "secret"}.to_json, set_headers
	
	expect(response.code.to_i).to eq 201
	expect(response_json).to eq({
		'email' => @user.email,
		'auth_token' => @user.auth_token,
		'auth_token_expires_at' => @user.auth_token_expires_at.to_json
		})
	end
end
