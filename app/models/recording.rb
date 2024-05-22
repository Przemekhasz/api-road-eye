class Recording < ApplicationRecord
  belongs_to :user

  mount_uploader :file_path, RecordingUploader

  validates :title, presence: true
  validates :file_path, presence: true
  validates :file_format, presence: true
  validates :duration, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_default_values
  after_commit :set_video_metadata, on: [:create, :update]

  private

  def set_default_values
    self.file_format ||= 'mp4'
    self.duration ||= 000
  end

  def set_video_metadata
    if file_path.present? && File.exist?(file_path.path)
      movie = FFMPEG::Movie.new(file_path.path)
      extension = File.extname(file_path.path).delete('.').downcase
      self.update_columns(file_format: extension, duration: movie.duration || 000)
    else
      Rails.logger.error("Plik nie istnieje lub nie został przekazany: #{file_path.inspect}")
    end
  end
end
