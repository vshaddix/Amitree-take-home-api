class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session = UserSessionManager.instance.create(user)

      response.headers['Authorization'] = session.hash_representation
    else
      render json: { data: [], message: "No user found" }, status: 422
    end
  end

  # test method
  def ping
    session = UserSessionManager.instance.setup_session_by_hash(request.headers['Authorization'])

    render json: { data: session }, status: 200
  end
end
