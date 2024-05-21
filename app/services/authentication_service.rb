class AuthenticationService
  def initialize(user_repository = UserRepository.new)
    @user_repository = user_repository
  end

  def authenticate(email, password)
    user = @user_repository.find_by_email(email)
    return nil unless user&.authenticate(password)

    token = encode_token({ user_id: user.id })
    { user: user, token: token }
  end

  private

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end
end
