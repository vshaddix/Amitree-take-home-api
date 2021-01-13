class UserController < ApplicationController
  # Route handler for GET: /user
  def index
    render json: { message: 'get all users' }, status: 200
  end

  # Route handler for POST: /user
  def create
    render json: { message: 'create a user' }, status: 200
  end

  # Route handler for PUT/PATCH: /user/:id
  def update
    render json: { message: 'update user' }, status: 200
  end

  # Route handler for DELETE: /user/:id
  def destroy
    render json: { message: 'delete user' }, status: 200
  end

  # Route handler for GET: /user/:id
  def show
    render json: { message: 'get single user' }, status: 200
  end
end
