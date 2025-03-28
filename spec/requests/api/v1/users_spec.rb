require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:headers) { { "Content-Type" => "application/json" } }
  let(:parsed_response) { JSON.parse(response.body) }

  describe 'POST /api/v1/users' do
    context 'when registration is successful' do
        let(:valid_user_params) do
            { 
              user: {
                name: 'John Doe',
                email: 'john@example.com',
                password: 'password123',
                password_confirmation: 'password123'
              }
            }
          end
          

      before { post '/api/v1/users', params: valid_user_params.to_json, headers: headers }

      it 'returns a 201 response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct success message' do
        expect(parsed_response["message"]).to eq("User registered successfully")
      end

      it 'returns the registered user details' do
        expect(parsed_response["data"]["user"]["email"]).to eq(valid_user_params[:user][:email])
      end

      it 'returns a valid authentication token' do
        expect(parsed_response["data"]["token"]).not_to be_nil
      end
    end

    context 'when registration fails due to validation errors' do
      let(:invalid_user_params) { { name: '', email: 'invalid_email', password: 'short' } }

      before { post '/api/v1/users', params: invalid_user_params.to_json, headers: headers }

      it 'returns a 422 response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        expect(parsed_response["message"]).to eq("User registration failed")
      end

      it 'includes validation error messages' do
        expect(parsed_response["errors"]).not_to be_empty
      end
    end
  end
end
