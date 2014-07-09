class User < ActiveRecord::Base
  #attr :username, :email, :firstname, :lastname, :avatar, :provider, :uid, :location, :from_mobileapp, 
  #:from_facebook, :facebook_picture

  before_save :ensure_authentication_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :login      

  validates :username,
            :uniqueness => { :case_sensitive => false },
            if: :from_facebook?
  
  validates_format_of :username, with: /\A[a-zA-Z\d]+\z/, 
                      message: "must contain only alphanumeric characters.", 
                      if: :from_facebook?

  validates :email,
            format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "email format incorrect." }

  has_many :selfies

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :comments


  def from_facebook?
    !self.from_facebook
  end

  def self.find_for_facebook_oauth(auth, from_mobileapp)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth[:provider]
      user.uid = auth[:uid]
      user.email = auth[:info][:email]
      user.password = Devise.friendly_token[0,20]
      user.username = auth[:info][:name]   # assuming the user model has a name
      user.firstname = auth[:info][:first_name]
      user.lastname = auth[:info][:last_name]
      user.facebook_picture = auth[:info][:image] # assuming the user model has an image
      user.from_facebook = true
      user.from_mobileapp = from_mobileapp
      user.skip_confirmation!       
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
