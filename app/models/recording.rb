class Recording < ApplicationRecord
  belongs_to :user
  has_many_attached :files

  validates :title, presence: true
  validates :files, presence: true
  validates :file_format, presence: true
  validates :duration, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_default_values
  after_commit :set_video_metadata, on: [:create, :update]

  private

  def set_default_values
    self.file_format ||= 'mp4'
    self.duration ||= 0
  end

  def set_video_metadata
    files.each do |file|
        temp_file_path = ActiveStorage::Blob.service.send(:path_for, file.blob.key)
        movie = FFMPEG::Movie.new(temp_file_path)
        extension = File.extname(file.filename.to_s).delete('.').downcase
        self.update_columns(file_format: extension, duration: movie.duration || 0)
    end
  end
end
