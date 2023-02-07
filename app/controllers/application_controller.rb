class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

  private

  def not_destroyed(parameter)
    render json: {errors: parameter.record.errors }, status: :unprocessable_entity
  end
end
