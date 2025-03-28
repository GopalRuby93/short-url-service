# frozen_string_literal:true

require 'rails_helper'

RSpec.describe ShortUrlGeneratorService, type: :service do
  describe "#call" do
    let(:short_url_params) { { original_url: "https://example.com", user_id: 1 } }

    context "when there are no existing ShortUrls" do
      it "generates a short URL with ID 1" do
        allow(ShortUrl).to receive(:maximum).with(:id).and_return(nil)
        
        service = ShortUrlGeneratorService.new(short_url_params)
        result = service.call

        expect(result).to be_a(ShortUrl)
        expect(result.short_url).to eq("0000001")
      end
    end

    context "when there are existing ShortUrls" do
      it "generates a short URL based on the next ID" do
        allow(ShortUrl).to receive(:maximum).with(:id).and_return(123)
      
        service = ShortUrlGeneratorService.new(short_url_params)
        result = service.call
      
        expect(result).to be_a(ShortUrl)
        expect(result.short_url).to eq("0000020")
      end      
    end

    it "ensures generated short URLs are always 7 characters long" do
      allow(ShortUrl).to receive(:maximum).with(:id).and_return(999_999_999)
      
      service = ShortUrlGeneratorService.new(short_url_params)
      result = service.call

      expect(result.short_url.length).to eq(7)
    end
  end

  describe "#base10_to_base62" do
    let(:service) { ShortUrlGeneratorService.new({}) }

    it "converts 0 to '0000000'" do
      expect(service.send(:base10_to_base62, 0)).to eq("0000000")
    end

    it "converts 1 to '0000001'" do
      expect(service.send(:base10_to_base62, 1)).to eq("0000001")
    end

    it "converts 62 to '0000010'" do
      expect(service.send(:base10_to_base62, 62)).to eq("0000010")
    end

    it "converts 123456 to a 7-character string" do
      result = service.send(:base10_to_base62, 123_456)
      expect(result.length).to eq(7)
    end
  end
end
