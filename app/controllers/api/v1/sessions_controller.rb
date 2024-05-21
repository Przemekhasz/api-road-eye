module Api
  module V1
    class SessionsController < ApplicationController
      def create
        auth_service = AuthenticationService.new
        auth_result = auth_service.authenticate(session_params[:email], session_params[:password])

        if auth_result
          render json: { token: auth_result[:token] }, status: :created
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
