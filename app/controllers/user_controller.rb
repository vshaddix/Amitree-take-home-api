class UserController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  # Route handler for GET: /user
  def index
    users = User.all
    render json: { data: users }, status: 200
  end

  # Route handler for POST: /user
  def create
    user = User.new(
      email: params[:email],
      password: params[:password],
      name: params[:name],
      referral_code: generate_user_referral_code,
      created_at: Time.now,
      updated_at: Time.now)

    if user.valid?
      session = UserSessionManager.instance.create(user)
      extract_referral_code

      if @referral_code_for_registration != nil
        inviter = User.find_by(referral_code: @referral_code_for_registration)
        referral_service = ReferralService.new

        referral_service.credit_newly_registered_user(user, inviter)
        referral_service.credit_inviter(inviter)
      end
      response.headers['Authorization'] = session.hash_representation

      render json: { data: user }, status: 201
    else
      render json: { data: user.errors, message: "Error creating user" }, status: 400
    end
  end

  # Route handler for PUT/PATCH: /user/:id
  def update
    user = User.find_by(id: params[:id])

    if user
      user.update(
        password: params[:password],
        name: params[:name],
        updated_at: Time.now
      )
      render json: { data: user }, status: 200
    else
      render json: { data: [], message: "No user found" }, status: 422
    end
  end

  # Route handler for DELETE: /user/:id
  def destroy
    user = User.find_by(id: params[:id])

    if user
      user.destroy
      render "", status: 200
    else
      render json: { data: [], message: "No user found" }, status: 422
    end
  end

  # Route handler for GET: /user/:id
  def show
    user = User.find_by(id: params[:id])

    if user
      render json: { data: user }, status: 200
    else
      render json: { data: [], message: "No user found" }, status: 422
    end
  end

  private

  # We want a unique referral code for each user
  # This is why this function can result in recursion until it finds a unique one
  # I use a simple and yet, not so optimised approach since we are not after performance here.
  # A possible optimisation would be to generate the code based on the email entered by the user.
  def generate_user_referral_code
    referral_code = (0...8).map { (65 + rand(26)).chr }.join

    User.find_by(referral_code: referral_code) === nil ? referral_code : generate_user_referral_code
  end

  def extract_referral_code
    @referral_code_for_registration = if params[:referral_code]
                                       params[:referral_code]
                                     else
                                       request.headers['HTTP_REFERRAL_CODE'] ? request.headers['HTTP_REFERRAL_CODE'] : nil
                                     end
  end
end
