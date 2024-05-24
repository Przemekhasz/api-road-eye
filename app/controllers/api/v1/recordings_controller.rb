module Api
  module V1
    class RecordingsController < ApplicationController
      before_action :authorize_request
      before_action :set_recording, only: %i[show update destroy stream]

      def index
        @recordings = Recording.all
        render json: @recordings.map { |recording| recording_attributes(recording) }
      end

      def show
        render json: recording_attributes(@recording)
      end

      def stream
        if @recording.files.attached?
          # Streaming the first attached file, adapt as necessary
          file = @recording.files.first
          redirect_to rails_blob_path(file, disposition: "inline")
        else
          render json: { error: 'File not found' }, status: :not_found
        end
      end

      def create
        Rails.logger.debug("Params: #{params.inspect}")
        @recording = @current_user.recordings.build(recording_params)

        if @recording.save
          Rails.logger.debug("Recording created with ID: #{@recording.id}")
          render json: recording_attributes(@recording), status: :created, location: api_v1_recording_url(@recording)
        else
          Rails.logger.error("Failed to create recording: #{@recording.errors.full_messages}")
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
        @recording = Recording.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Recording not found' }, status: :not_found
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
