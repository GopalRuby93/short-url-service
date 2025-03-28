# frozen_string_literal:true

require "rails_helper"

RSpec.describe User, type: :model do
    describe "validations" do
      it "is valid with valid attributes" do
        user = described_class.new(name:"Gopal Chakraborty", email:"gopalchakraborty93@gmail.com", password: "12345678", password_confirmation:"12345678")
        expect(user).to be_valid
      end

      it "is not valid without a name" do
        user = described_class.new(name: nil, email:"gopalchakraborty193@gmail.com",password: "123456", password_confirmation:"123456" )
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it "is not valid without a email" do
        user = described_class.new(name: "Gopal Chakraborty", email: nil,password: "123456", password_confirmation:"123456")
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "is not valid with a duplicate email" do
        described_class.create(name:"Gopal Chakraborty", email:"gopalchakraborty193@gmail.com", password: "12345678", password_confirmation:"12345678")
        user = described_class.new(name:"John Doe", email:"gopalchakraborty193@gmail.com", password: "12345678", password_confirmation:"12345678")
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("has already been taken")
      end
    end
end
