class ApplicationController < ActionController::API
  before_action :authenticate_request
    attr_reader :current_user

  private

  def authenticate_request
    @current_session = UserSessionManager.instance.setup_session_by_hash(request.headers['Authorization'])
    render json: { error: 'Not Authorizedddd' }, status: 401 unless @current_session
  end
end
