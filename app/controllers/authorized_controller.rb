class AuthorizedController < ApiController
  before_action :unauthorized_request

  def unauthorized_request
    render status: :unauthorized unless current_user
  end
end
