class RecordingRepository
  def initialize
    @relation = Recording.all
  end

  def find_all_by_user(user)
    user.recordings
  end

  def find_by_user_and_id(user, id)
    user.recordings.find(id)
  end

  def create(user, params)
    user.recordings.create(params)
  end

  def update(recording, params)
    recording.update(params)
  end

  def destroy(recording)
    recording.destroy
  end
end
