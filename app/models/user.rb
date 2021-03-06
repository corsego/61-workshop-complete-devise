class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :trackable, :lockable,
         :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2, :github]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0,20]
      )
    end
    user.skip_confirmation!
    user
  end

end
