class RecordingUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def extension_allowlist
    %w(mp4 avi mkv mov)
  end
end
