module ApiExceptionsHandler
  extend ActiveSupport::Concern

  included do
    around_action :handle_exceptions
  end

  def handle_exceptions
    yield
  rescue ActiveRecord::RecordNotFound => e
    handle_record_not_found(e)
  rescue ActiveModel::ValidationError, ActiveRecord::RecordInvalid, ArgumentError => e
    handle_validation_error(e)
  rescue ActionController::ParameterMissing => e
    handle_parameter_missing(e)
  rescue StandardError => e
    handle_standard_error(e)
  end

  private

  def handle_record_not_found(exception)
    error_message = "Record not found for #{exception.model}"
    respond_with_error(error_message, 'Record not found', 404)
  end

  def handle_validation_error(exception)
    respond_with_error(exception.record.errors.full_messages, 'Validation failed', 422)
  end

  def handle_parameter_missing(exception)
    respond_with_error(exception.message, 'Bad request - Missing parameters', 400)
  end

  def handle_standard_error(exception)
    respond_with_error(exception.message, 'Internal Server Error', 500)
  end

  def respond_with_error(error, message, status)
    if request.format.json?
      render_error_response(error: error, message: message, status: status)
    else
      flash[:error] = message
    #   redirect_to root_path
    end
  end
end
