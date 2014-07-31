class User < ActiveRecord::Base
  #attr :username, :email, :firstname, :lastname, :avatar, :provider, :uid, :location, :from_mobileapp, 
  #:from_facebook, :facebook_picture

  before_save :ensure_authentication_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:facebook]

  extend FriendlyId
  friendly_id :username, use: :slugged       

  acts_as_followable
  acts_as_follower

  attr_accessor :login      

  validates :username,
            :uniqueness => { :case_sensitive => false },
            if: :not_from_facebook?
  
  validates_format_of :username, with: /\A[a-zA-Z\d]+\z/, 
                      message: "must contain only alphanumeric characters.", 
                      if: :not_from_facebook?

  validates_presence_of :firstname, :lastname, :email, :username, message: 'Field cannot be empty.'                        

  validates :email,
            format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "email format incorrect." }

  has_many :selfies
  has_many :comments

  has_attached_file :avatar, 
                    :styles => {:thumb => "" }, 
                    :convert_options => { :thumb => "-gravity Center -crop 500x500+0+0 +repage -resize 400x400^" },
                    :default_url => "/images/:style/missing.png"
  
  validates_attachment :avatar,
            :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
            :size => { :in => 0..5.megabytes }

  def not_from_facebook?
    !self.from_facebook
  end

  def self.find_for_facebook_oauth(auth, from_mobileapp)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      puts "PROVIDER : " + auth[:provider] + "\n"
      puts "UID : " + auth[:uid] + "\n"
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

  def show_profile_picture
    if self.not_from_facebook?
        self.avatar.url(:thumb)
    else
      if self.avatar.blank?
        self.facebook_picture
      else            
        self.avatar.url(:thumb)
      end
    end
  end

  def accept_follow(user)
    follow = Follow.where("follower_id = ? and followable_id = ?", user.id, current_user.id).limit(1)
    # accept follow request
    follow.status = 1
    follow.save
  end

  def reject_follow(user)
    follow = Follow.where("follower_id = ? and followable_id = ?", user.id, current_user.id).limit(1)
    # accept follow request
    follow.destroy    
  end

  def followers(status)
    user_followers = Follow.where('status = ? and followable_id = ?', status, self.id);
    followers = []
    user_followers.each do |f|
      user = User.friendly.find(f.follower_id)
      followers << user
    end
    followers
  end

  def following_status(user)
    follow = Follow.find_by followable_id: user.id, follower_id: self.id;    
    follow.status
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
