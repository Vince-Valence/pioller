# frozen_string_literal: true

class UsersController < ApplicationController
  include Secured

  before_action :set_user, only: %i[show edit update destroy]
  before_action :logged_in?, only: %i[edit update destroy]
  before_action :is_current_user?, only: %i[edit update destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:followers).all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to @user, notice: 'User was successfully created.'
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: 422 }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to @user, notice: 'User was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html do
        redirect_to users_url, notice: 'User was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.includes(followers: :follower_relationships, following: :follower_relationships).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white
  # list through.
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password,
                                 :password_confirmation)
  end

  def is_current_user?
    redirect_to(root_path, notice: 'Unauthorized access!') unless @user == current_user
  end
end
