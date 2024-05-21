class UserService
  def initialize(user_repository = UserRepository.new)
    @user_repository = user_repository
  end

  def get_all_users
    @user_repository.all
  end

  def get_user_by_id(id)
    @user_repository.find_by_id(id)
  end

  def create_user(params)
    @user_repository.create(params)
  end

  def update_user(user, params)
    @user_repository.update(user, params)
  end

  def delete_user(user)
    @user_repository.destroy(user)
  end
end
