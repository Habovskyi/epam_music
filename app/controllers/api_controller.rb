# Please create new controllers via inheriting this controller
# Example of new controller creating: class NewController < ApiController; end
class ApiController < ActionController::API
  include ActionPolicy::Controller

  rescue_from ActionPolicy::Unauthorized, with: :forbidden_response
  rescue_from ActiveRecord::RecordNotFound, Pagy::OverflowError, Pagy::VariableError, with: :not_found_response

  authorize :user, through: :current_user

  def auth_header
    request.headers['Authorization'] || ''
  end

  def current_user
    token = auth_header.split[1]
    user_id = JsonWebToken.payload(token)[:user_id]
    ::User.where(active: true).find_by(id: user_id)
  rescue NoMethodError, JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def serialize(serializer, object, options = {})
    options[:include] = params[:includes]&.map(&:to_sym) & serializer.includes
    serializer.new(object, **options)
  end

  def forbid_authenticated
    render json: { message: I18n.t('endpoints.errors.client.already_logged') }, status: :forbidden if logged_in?
  end

  def forbidden_response
    render status: :forbidden
  end

  def not_found_response
    render status: :not_found
  end

  def logged_in?
    !!current_user
  end
end
