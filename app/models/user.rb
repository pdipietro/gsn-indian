require 'digest'
class User
  include Neo4j::ActiveNode
  include CustomNeo4j
  
  property :id
  property :first_name
  property :last_name
  property :country
  property :color#, default: "#FF0000"

  # property :remember_token
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :uuid
  property :ns

  property :other_languages, type: Object
  property :default_language

  # property :uuid, default: SecureRandom.uuid


  # validates :uuid, presence: true
  # validate :id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true



  # property :confirmation_token
  # property :confirmed_at, type: DateTime
  # property :confirmation_sent_at, type: DateTime
  
  has_n(:identities).to(UserIdentity)

  before_destroy :delete_identities

  # before_create :create_confirmation_token, if: :is_normal_provider?
  # before_create :set_user
  # after_create  :send_email_confirmation, if: :is_normal_provider?
  after_create :create_users_relation

  # attr_accessor :provider

  # class << self
  # 	def new_random_token
  #     SecureRandom.urlsafe_base64
  #   end

  #   def hash(token)
  #     Digest::SHA1.hexdigest(token.to_s)
  #   end

  # end

  # def confirmed?
  # 	get_identity("normal").confirmed_at.present?
  # end

  def full_name
    "#{first_name} #{last_name}"
  end
 
  def delete_identities
    self.identities.map{|identity| identity.destroy if identity.present?}
  end

  #  def create_confirmation_token
  #   # Create the confirmation token.
  #    self.confirmation_token = UserIdentity.hash(UserIdentity.new_random_token)
  #    self.confirmation_sent_at = Time.now.utc
  #  end

  # def send_email_confirmation
  #   Notification.send_confirmation_email(self).deliver
  # end

  # def is_normal_provider?
  # 	provider == "normal"
  # end

  # def email
  #   normal_identity.email
  # end

  def get_identity(provider)
  	identities.find(provider: provider).next
  end

  def create_users_relation
    # social_network = get_social_network.next
    self.create_rel(:_IS_INSTANCE_OF, get_user_model)
    self.create_rel(:_HAS_VERSION, get_version)
    self.create_rel(:_HAS_TRANSLATION, get_translation(self.full_name, self.default_language))
  end  

  def get_user_model 
    model_id = Neo4j::Session.query('match (n:Model{name: "user"}) RETURN ID(n)').data.flatten.last
    Neo4j::Node.load(model_id)
  end

end

