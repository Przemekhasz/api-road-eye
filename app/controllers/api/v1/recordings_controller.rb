module Api
  module V1
    class RecordingsController < ApplicationController
      before_action :authorize_request
      before_action :set_recording, only: %i[show update destroy stream]

      def index
        @recordings = Recording.all
        render json: @recordings
      end

      def show
        render json: @recording
      end

      def stream
        file_path = @recording.file_path.path
        if File.exist?(file_path)
          send_file file_path, type: 'video/mp4', disposition: 'inline'
        else
          render json: { error: 'File not found' }, status: :not_found
        end
      end

      def create
        @recording = @current_user.recordings.build(recording_params)

        if @recording.save
          render json: @recording, status: :created, location: api_v1_recording_url(@recording)
        else
          render json: @recording.errors, status: :unprocessable_entity
        end
      end

      def update
        if @recording.update(recording_params)
          render json: @recording
        else
          render json: @recording.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @recording.destroy
      end

      private

      def set_recording
        @recording = Recording.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Recording not found' }, status: :not_found
      end

      def recording_params
        params.require(:recording).permit(:title, :description, :file_path)
      end
    end
  end
end
