class SessionsController < ApplicationController
  before_filter :signed_in_user, except: [:destroy]

  def new
    
    # Neo4j::Session.query('match (n:Model{name: "user identity"}) return n;')
  end

  def create    
    identity = UserIdentity.find(conditions: {email: params[:session][:email].downcase})
   
    if identity && UserIdentity.encrypt_password(identity.email, params[:session][:password]) == identity.password
      # Sign the user in and redirect to the user's show page.
      sign_in_user(identity, "normal")     
      redirect_to user_path(identity.user.neo_id)
    else
      # Create an error message and re-render the signin form.
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
  	sign_out
    redirect_to root_url
  end

  def confirm_user
    identity = UserIdentity.find(conditions: {confirmation_token: params[:token]})    
    if identity.present?
      identity.confirmed_at = Time.now
      identity.confirmation_token = ""
      identity.save
      sign_in(identity, "normal")
      redirect_to user_path(identity.user)
    else
      redirect_to root_path, error: "Token is invalid"
    end
  end

  private

  def signed_in_user
    if signed_in?
       redirect_to root_path, :flash => { :error => "You have already signed in." }
    end
  end

  def sign_in_user(identity, provider)
    remember_token = UserIdentity.new_random_token
    cookies.permanent[:remember_token] = remember_token
    identity.update(remember_token: UserIdentity.hash(remember_token))
    # identity = identity.get_identity(provider)
    self.current_identity = identity
    self.current_user = identity.user
    flash[:success] = "Signed in successfully"
  end
  
end
