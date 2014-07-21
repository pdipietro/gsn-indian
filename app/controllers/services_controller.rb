class ServicesController < ApplicationController

  def create 
    auth = env["omniauth.auth"] 
    provider = auth.provider
  
    email = (auth.info.try(:email).present?) ? auth.info.email : "#{auth.info.nickname}@#{auth.provider}.com"
    oauth_token = auth.credentials.token
    oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
   
    identity = UserIdentity.find(conditions: {email: email})    
    if identity.blank?       
      identity = from_omniauth(auth, current_user, email, provider)      
    end

    identity.identity_provider(provider, auth.uid, oauth_token, oauth_expires_at)

    unless identity.errors.any?
      unless signed_in?  
        sign_in_user(identity, provider)
      end
      flash[:success] = "Signed in successfully with #{provider}"      
      if identity.user == current_user
        redirect_to user_path(identity.user)
      else
        redirect_to root_path
      end
    else      
      redirect_to root_path, :flash => { :error => show_error_messages(identity) }
    end          
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
  
  private

    def from_omniauth(auth, c_user, email, provider)
      country = auth.info.location.split(',')[1].strip if auth.info.location.present?
      country ||= "country"
      language = if (auth.extra.present? and auth.extra.raw_info.present?)
                    auth.extra.raw_info.lang
                  else
                    'en'
                  end       
      if provider=="twitter"
        first_name =  auth.info.name.split(" ")[0] 
        last_name =  auth.info.name.split(" ")[1] 
      else
        first_name =  auth.info.first_name 
        last_name =  auth.info.last_name 
      end
      user = if c_user.present?
                c_user
             else
               User.create(first_name: first_name,
                           last_name: last_name,                         
                           country: country ,
                           other_languages: language,
                           default_language: [language],                       
                           ns: "ki"                        
                           ) 
              end

       
        identity = UserIdentity.new
        
        # identity.provider = auth.provider
        # identity.uid = auth.uid
        identity.email = email
        identity.nickname = auth.info.nickname     
        identity.country = country      
        identity.ns = "ki"

        if identity.save       
          user.identities << identity 
          # identity.user = user         
        end
       
        return identity                 

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
