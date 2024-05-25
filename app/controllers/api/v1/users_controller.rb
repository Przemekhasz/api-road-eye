module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, except: :create
      before_action :set_user, only: %i[show update destroy]

      def index
        user_service = UserService.new
        @users = user_service.get_all_users

        render json: @users, include: :profile
      end

      def show
        render json: @user, include: :profile
      end

      def create
        user_service = UserService.new
        @user = user_service.create_user(user_params)

        if @user.persisted?
          render json: @user, include: :profile, status: :created, location: api_v1_user_url(@user)
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        user_service = UserService.new

        if user_service.update_user(@user, user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        user_service = UserService.new
        user_service.delete_user(@user)
      end

      def current
        render json: @current_user, include: :profile
      end

      private

      def set_user
        user_service = UserService.new
        @user = user_service.get_user_by_id(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, roles: [], profile_attributes: [:first_name, :last_name, :voivodeship, :country, :city])
      end
    end
  end
end
