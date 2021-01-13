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
      created_at: Time.now,
      updated_at: Time.now)

    if user.save
      session = UserSessionManager.instance.create(user)

      response.headers['Authorization'] = session.hash_representation

      render json: { data: user }, status: 201
    else
      render json: { data: null, message: "Error creating user" }, status: 400
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
end
