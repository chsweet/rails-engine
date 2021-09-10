class ApplicationController < ActionController::API
  # rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
  # rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  #
  # def render_record_invalid(exception)
  #   render json: exception.record.errors, status: :bad_request
  # end
  #
  # def render_record_not_found(exception)
  #   render json: { error: exception.message }, status: :not_found
  # end
end
