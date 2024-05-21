class UserRepository
  def initialize
    @relation = User.all
  end

  def find_by_id(id)
    @relation.find(id)
  end

  def find_by_email(email)
    @relation.find_by(email: email)
  end

  def all
    @relation
  end

  def create(params)
    User.create(params)
  end

  def update(user, params)
    user.update(params)
  end

  def destroy(user)
    user.destroy
  end
end
