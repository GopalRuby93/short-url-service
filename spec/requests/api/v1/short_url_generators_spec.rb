require "rails_helper"
require "swagger_helper"

RSpec.describe Api::V1::ShortUrlGeneratorsController, type: :request do
  let(:user) { User.create(name:"Gopal Chakraborty", email:"gopalchakraborty1993@gmail.com", password: "12345678", password_confirmation:"12345678") }
  let(:headers) { { "Content-Type" => "application/json" } }
  let(:valid_params) do
    {
      short_url: {
        original_url: "https://example.com"
      }
    }
  end
  let(:invalid_params) do
    {
      short_url: {
        original_url: ""
      }
    }
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "POST /api/v1/short_url_generators" do
    context "when valid params are provided" do
      it "creates a short URL and returns 200" do
        expect {
          post "/api/v1/short_url_generators", params: valid_params.to_json, headers: headers
        }.to change(ShortUrl, :count).by(1)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Short url created successfully")
        expect(json_response["data"]["short_url"]).to be_present
      end
    end

    context "when invalid params are provided" do
      it "returns an error with status 422" do
        post "/api/v1/short_url_generators", params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Short url creation failed")
        expect(json_response["errors"]).to be_present
      end
    end
  end

  describe "GET /:short_code" do
    let!(:short_url) { ShortUrl.create(original_url: "https://example.com", short_url: "http://www.example.com/abc123", user:user) }

    context "when the short URL exists" do
      it "redirects to the original URL with 302 status" do
        get "/abc123"
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to("https://example.com")
      end
    end

    context "when the short URL does not exist" do
      it "returns a 422 error" do
        get "/invalid_code"

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Short url not found")
      end
    end
  end
end
