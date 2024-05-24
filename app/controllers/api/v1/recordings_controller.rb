module Api
  module V1
    class RecordingsController < ApplicationController
      before_action :authorize_request
      before_action :set_recording, only: %i[show update destroy stream]
      before_action :set_user_recordings, only: %i[user_recordings]

      def index
        @recordings = Recording.all
        render json: @recordings.map { |recording| recording_attributes(recording) }
      end

      def show
        render json: recording_attributes(@recording)
      end

      def user_recordings
        render json: @user_recordings.map { |recording| recording_attributes(recording) }
      end

      def stream
        if @recording.files.attached?
          file = @recording.files.first
          redirect_to rails_blob_path(file, disposition: "inline")
        else
          render json: { error: 'File not found' }, status: :not_found
        end
      end

      def create
        @recording = @current_user.recordings.build(recording_params)

        if @recording.save
          render json: recording_attributes(@recording), status: :created, location: api_v1_recording_url(@recording)
        else
          render json: @recording.errors, status: :unprocessable_entity
        end
      end

      def update
        if @recording.update(recording_params)
          render json: recording_attributes(@recording)
        else
          render json: @recording.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @recording.destroy
        head :no_content
      end

      private

      def set_recording
        @recording = @current_user.recordings.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Recording not found' }, status: :not_found
      end

      def set_user_recordings
        @user_recordings = @current_user.recordings
      end

      def recording_params
        params.require(:recording).permit(:title, :description, files: [])
      end

      def recording_attributes(recording)
        {
          id: recording.id,
          title: recording.title,
          description: recording.description,
          files: recording.files.map { |file| url_for(file) },
          created_at: recording.created_at,
          updated_at: recording.updated_at
        }
      end
    end
  end
end
