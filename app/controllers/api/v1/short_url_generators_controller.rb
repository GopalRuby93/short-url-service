class Api::V1::ShortUrlGeneratorsController < ApplicationController
  before_action :authenticate_user, only: [:create]

  def create
    short_url_data = ShortUrlGeneratorService.new(short_url_params.merge(user:current_user)).call
    short_code = short_url_data[:short_url]
    short_url_data[:short_url] = "#{request.base_url}/#{short_code}"
    if short_url_data.save
      render_success_response(data: { short_url: short_url_data.short_url}, message: "Short url created successfully", status:200)
    else
      render_error_response(error: short_url_data.errors.full_messages, message: "Short url creation failed", status:422)
    end    
  end

  def short_url

    short_url = "#{request.base_url}/#{params[:short_url]}"
    short_url_data = ShortUrl.find_by(short_url:short_url)
    if short_url_data
      redirect_to short_url_data.original_url, allow_other_host: true, status:302
    else
      render json: { error: "Short url not found", message: "Short url not found" }, status:422
    end
  end

  private

  def short_url_params
    params.require(:short_url).permit(ShortUrl::PERMITTED_ATTRIBUTES)
  end
end
