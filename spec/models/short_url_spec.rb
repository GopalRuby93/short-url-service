# frozen_string_literal:true

require "rails_helper"

RSpec.describe ShortUrl, type: :model do
    let(:user) { User.create(name:"Gopal Chakraborty", email:"gopalchakraborty1993@gmail.com", password: "12345678", password_confirmation:"12345678") }
    describe "validations" do
      it "is valid with valid attributes" do
        short_url = described_class.new(original_url: "https://enginebogie.com", user:user)
        expect(short_url).to be_valid
      end

      it "is not valid without a original_url" do
        short_url = described_class.new(original_url: nil, user:user)
        expect(short_url).not_to be_valid
        expect(short_url.errors[:original_url]).to include("can't be blank")
      end

      it "is not valid without a user" do
        short_url = described_class.new(original_url: "https://enginebogie.com", user:nil)
        expect(short_url).not_to be_valid
        expect(short_url.errors[:user]).to include("must exist")
      end
    end
end
