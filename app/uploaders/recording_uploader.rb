class RecordingUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_extension_inclusion %w[mp4 avi mkv mov]
  end
end
