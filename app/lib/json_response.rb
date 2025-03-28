# frozen_string_literal: true

class JsonResponse
  attr_reader :success, :data, :message, :errors

  def initialize(options = {})
    @data = options[:data] || []
    @message = options[:message] || ''
    @errors = options[:errors] || []
    @success = options[:success] || false
  end

  def as_json(*)
    {
      data: data,
      message: message,
      errors: errors,
      success: success
    }
  end
end
