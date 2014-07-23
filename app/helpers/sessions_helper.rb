module SessionsHelper

  def sign_in(identity, provider)
    remember_token = UserIdentity.new_random_token
    cookies.permanent[:remember_token] = remember_token
    identity.update(remember_token: UserIdentity.hash(remember_token))
    # identity = identity.get_identity(provider)

    self.current_identity = identity
    self.current_user = identity.user
    flash[:success] = "Signed in successfully"
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    user = current_identity.try(:user)     
    User.find(user.neo_id) if user.present?  
  end


  def current_user?(user)
    user == current_user
  end

  def current_identity=(identity)
    @current_identity = identity
  end

  def current_identity     
    remember_token = UserIdentity.hash(cookies[:remember_token])      
    @current_identity ||= UserIdentity.find(conditions: {remember_token: remember_token})
   
  end

  def current_identity?(identity)
    identity == current_identity
  end


  def signed_in?  
    !current_identity.nil? && current_identity.confirmed?
  end

  def sign_out
    current_identity.update(remember_token: UserIdentity.hash(UserIdentity.new_random_token)) if current_identity.present?
    cookies.delete(:remember_token)
    self.current_identity = nil
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def signed_in_user
   unless signed_in?
     store_location
     redirect_to signin_url, info: "Please sign in."
   end
 end

 def get_left_menu_data
    Neo4j::Session.query("match (n:Application:Model)<-[r:_]-(m)<-[k]-(p) return m,p;")
 end

end