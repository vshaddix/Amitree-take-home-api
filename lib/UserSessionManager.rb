class UserSessionManager
  include Singleton

  # We would like to always know that the user has only one session currently active.
  # So each request could update only the `expires_on` column of the entity.
  # This will allow us to have a private date of the users session stored in the database.
  # Which could be later on manipulated.
  #   Ex: Storing data
  # This method should be used only when a user does the following actions:
  #   - register
  #   - logs in
  def create(user)
    active_session = UserSession.where('expires_on > ?', Time.now).where(user_id: user.id).first

    if active_session != nil
      update_expire_time(active_session)
      @active_session = active_session

      return @active_session
    end

    hash_representation = (Digest::SHA1.hexdigest Time.now.getutc.to_s)
    @active_session = UserSession.new(
      user: user,
      expires_on: (Time.now + 30*60),
      data: "",
      hash_representation: hash_representation,
      created_at: Time.now,
      updated_at: Time.now)

    if @active_session.save
      @active_session
    else
      #TODO: this could be improved with custom exception
      # raise "Session could not be created"

      false
    end
  end

  # Method used to authenticate the user on each request to the API
  # This should be used with the hash sent with the headers of the request.
  def setup_session_by_hash(hash)
    active_session = UserSession.where('expires_on > ?', Time.now).where(hash_representation: hash).first

    if active_session === nil
      #TODO: this could be improved with custom exception
      # raise "Session not found or expired"

      return false
    end

    update_expire_time(active_session)
    @active_session = active_session

    active_session
  end

  private

  def update_expire_time(session)
    session.expires_on = Time.now + 30*60
    session.save

    session
  end
end