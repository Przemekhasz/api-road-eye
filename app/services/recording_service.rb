class RecordingService
  def initialize(recording_repository = RecordingRepository.new)
    @recording_repository = recording_repository
  end

  def get_all_recordings(user)
    @recording_repository.find_all_by_user(user)
  end

  def get_recording_by_id(user, id)
    @recording_repository.find_by_user_and_id(user, id)
  end

  def create_recording(user, params)
    @recording_repository.create(user, params)
  end

  def update_recording(recording, params)
    @recording_repository.update(recording, params)
  end

  def delete_recording(recording)
    @recording_repository.destroy(recording)
  end
end
