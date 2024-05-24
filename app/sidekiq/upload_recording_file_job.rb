class UploadRecordingFileJob
  include Sidekiq::Job

  def perform(recording_id, file_paths)
    Rails.logger.debug("Starting job to upload file for recording ID: #{recording_id}")
    recording = Recording.find(recording_id)

    file_paths.each do |file_path|
      next unless File.exist?(file_path)

      file = File.open(file_path)
      Rails.logger.debug("Processing file: #{file_path}")
      begin
        recording.file_attacher.assign(io: file, filename: File.basename(file_path), content_type: MIME::Types.type_for(file_path).first.content_type)
        Rails.logger.debug("Assigned file: #{file_path}")
      rescue => e
        Rails.logger.error("Failed to assign file: #{e.message}")
      ensure
        file.close
      end

      begin
        File.delete(file_path)
        Rails.logger.debug("Deleted temp file: #{file_path}")
      rescue => e
        Rails.logger.error("Failed to delete temp file: #{e.message}")
      end
    end

    if recording.save
      Rails.logger.debug("Recording updated with file data")
    else
      Rails.logger.error("Failed to save recording with file data: #{recording.errors.full_messages}")
    end
  end
end
