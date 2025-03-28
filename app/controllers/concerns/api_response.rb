module ApiResponse
  extend ActiveSupport::Concern

  def json_response(options = {},status=500)
    render json: JsonResponse.new(options),status:
  end

  def render_success_response(data:{},message:'',status:200)
    json_response({data:,message:message,success:true},status)
  end

  def render_error_response(error:, message:, status:)
    json_response({ message: message, success: false, errors: error }, status)
  end
end