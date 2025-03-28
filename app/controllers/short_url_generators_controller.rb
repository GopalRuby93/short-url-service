class ShortUrlGeneratorsController < ApplicationController
    before_action :authenticate_user
  
    def new
      @short_url = ShortUrl.new
    end  
  
    def create
      @short_url_data = ShortUrlGeneratorService.new(short_url_params.merge(user:current_user)).call
      short_code = @short_url_data[:short_url]
      @short_url_data[:short_url] = "#{request.base_url}/#{short_code}"
      if @short_url_data.save
        flash.now[:notice] = "Shortened URL created successfully! You can use it now."
        render :show
      else
        flash.now[:alert] = @short_url_data.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def short_url_params
      params.require(:short_url).permit(ShortUrl::PERMITTED_ATTRIBUTES)
    end
  end
  