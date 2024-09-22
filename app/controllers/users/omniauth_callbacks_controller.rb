class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth("google")
  end

  def github
    handle_auth("github")
  end

  def facebook
    handle_auth("facebook")
  end

  private

  def handle_auth(kind)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      UserMailer.new_user(@user).deliver_later
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: kind
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{kind}_data"] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end