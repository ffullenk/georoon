class AuthenticationsController < ApplicationController
  
  def create
  auth = request.env["omniauth.auth"]
 
  # Try to find authentication first
  authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
 
  if authentication
    # Authentication found, sign the user in.
    flash[:notice] = "Ingreso exitoso."
    sign_in_and_redirect(:user, authentication.user)
  else
    # Authentication not found, thus a new user.
    user = User.new
    user.apply_omniauth(auth)
    if user.save(:validate => false)
      flash[:notice] = "Cuenta creada, ingreso exitoso."
      sign_in_and_redirect(:user, user)
    else
      flash[:error] = "Error al crear la cuenta, reintente."
      redirect_to root_url
    end
  end
end
end
