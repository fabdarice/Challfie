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


  searchable do 
    text :username, :boost => 5.0
    text :firstname
    text :lastname, :boost => 3.0
    text :email
  end  

  acts_as_voter
  
  acts_as_followable
  acts_as_follower

  attr_accessor :login      

  validates :username,
            :uniqueness => { :case_sensitive => false },
            if: :not_from_facebook?

  validates_presence_of :firstname, :lastname, :email, :username
  validates_length_of :username, within: 2..20, if: :not_from_facebook?            

  validates_format_of :username, with: /\A[a-zA-Z\d]+\z/, 
                      message: I18n.translate('sign_in.error_username_format'), 
                      if: :not_from_facebook?                          

  validates :email,
            format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: I18n.translate('sign_in.email_format') }

  has_one :facebook_info
  has_many :selfies
  has_many :comments
  has_many :notifications

  has_many :books, :through => :book_users
  has_many :book_users, dependent: :destroy
  
  

  has_attached_file :avatar, 
                    :styles => {:thumb => "" }, 
                    :convert_options => { :thumb => Proc.new { |instance| instance.avatar_dimension } },
                    :default_url => "/assets/missing.jpg"
  
  validates_attachment :avatar,
            :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
            :size => { :in => 0..5.megabytes }

  def avatar_dimension(size=400)
    dimensions = Paperclip::Geometry.from_file(avatar.queued_for_write[:original].path)
    min = dimensions.width > dimensions.height ? dimensions.height : dimensions.width
    "-gravity Center -crop #{min}x#{min}+0+0 +repage -resize #{size}x#{size}^"
  end            

  def not_from_facebook?
    !self.from_facebook
  end

  def self.find_for_facebook_oauth(auth, from_mobileapp)        

    # to replace his actual email with @facebook.com email to fix the problem of having a doublon
    email_splitter = auth[:info][:email].split("@")
    user_facebook_email = email_splitter[0] + "@facebook.com"

    facebook_user = where(auth.slice(:provider, :uid)).first_or_initialize do |user|    
      user.provider = auth[:provider]
      user.uid = auth[:uid]      
      user.email = user_facebook_email
      user.password = Devise.friendly_token[0,20]
      user.username = auth[:info][:name]   # assuming the user model has a name
      user.firstname = auth[:info][:first_name]
      user.lastname = auth[:info][:last_name]
      user.facebook_picture = auth[:info][:image].gsub!("http", "https") # assuming the user model has an image
      user.oauth_token = auth[:credentials][:token]
      user.oauth_expires_at = auth[:credentials][:expires_at]
      user.from_facebook = true
      user.from_mobileapp = from_mobileapp      
      user.skip_confirmation!             
    end
        

    facebook_user.update_attributes(email: user_facebook_email, 
                                    username: auth[:info][:name], 
                                    firstname: auth[:info][:first_name],
                                    oauth_token: auth[:credentials][:token],
                                    oauth_expires_at: Time.at(auth[:credentials][:expires_at]),
                                    facebook_picture: auth[:info][:image].gsub!("http", "https")) 
    facebook_user.save                                   

    facebook_info = FacebookInfo.find_by(user_id: facebook_user.id)
          
    if facebook_info == nil
      facebook_info = FacebookInfo.new(facebook_uid: auth[:uid], facebook_lastname: auth[:info][:last_name],
                                     facebook_firstname: auth[:info][:first_name], facebook_email: auth[:info][:email], facebook_locale: auth[:extra][:raw_info][:locale])
      facebook_info.user = facebook_user
    else
      facebook_info.update_attributes(facebook_uid: auth[:uid], facebook_lastname: auth[:info][:last_name],
                                     facebook_firstname: auth[:info][:first_name], facebook_email: auth[:info][:email], facebook_locale: auth[:extra][:raw_info][:locale])
    end
    
    facebook_info.save
    return facebook_user
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

  # If status = false : Return list of users self is following with pending request
  # If status = true : Return list of users self is following
  def following(status)
    user_following = Follow.where('status = ? and follower_id = ? and blocked = false', status, self.id);
    following = []
    user_following.each do |f|
      user = User.friendly.find(f.followable_id)
      following << user
    end
    following = following.sort_by{|u| u.username.downcase}
  end

  # If status = false : Return list of pending request
  # If status = true : Return list of followers (users who are following you)
  def followers(status)
    user_followers = Follow.where('status = ? and followable_id = ? and blocked = false', status, self.id);
    followers = []
    user_followers.each do |f|
      user = User.friendly.find(f.follower_id)
      followers << user
    end
    followers = followers.sort_by{|u| u.username.downcase}
  end

  # return true if the status is approved
  # return false if the status is pending or doesn't exist
  def following_status(user)
    follow = Follow.find_by followable_id: user.id, follower_id: self.id;    
    if !follow.blank?
      follow.status
    else
      return false
    end
  end

  def add_notifications(message_en, message_fr, author, selfie, book)    
    @notification = self.notifications.build(message_en: message_en, message_fr: message_fr, author: author, selfie: selfie, book: book)
    @notification.save
  end


  # return list of block users by self user
  def block_by_users
    follows_block = Follow.blocked.where("follower_id = ? OR followable_id = ?", self.id, self.id)
    @users_block = []
    follows_block.each do |f|
      @users_block << User.friendly.find(f.followable_id)
      @users_block << User.friendly.find(f.follower_id)
    end
    @users_block
  end


  def friends_suggestions 
    @friends_suggestion = []    
    # Add Mutual friends from Facebook
    if (!self.uid.blank? or (self.facebook_info and !self.facebook_info.facebook_uid.blank?)) and !self.oauth_token.blank?                  
      begin                
        @graph = Koala::Facebook::API.new(self.oauth_token)                   
        facebook_friends = @graph.get_connections("me", "friends")  
        facebook_friends.each do |fb_friend|
          facebook_info = FacebookInfo.where(facebook_uid: fb_friend['id']).first
          fb_friends_sug = User.find_by uid: fb_friend['id']
          # ADD TO SUGGESTION IF NOT ALREADY FOLLOWING
          @friends_suggestion << fb_friends_sug if not fb_friends_sug.blank? and not self.following?(fb_friends_sug)
          if facebook_info and (facebook_info.user != fb_friends_sug)
            # ADD TO SUGGESTION IF NOT ALREADY FOLLOWING
            @friends_suggestion << facebook_info.user if not self.following?(facebook_info.user)
          end
        end
      rescue Koala::Facebook::APIError
        logger.debug "[OAuthException] Either the user's access token has expired, they've logged out of Facebook, deauthorized the app, or changed their password"
        self.oauth_token = nil 
        self.save       
      end 
    end   

    dbconfig = YAML::load_file("config/database.yml")[Rails.env]
    dbconfig["host"] = dbconfig["hostname"]

    client = Mysql2::Client.new(dbconfig)
    # Call a stored procedure to retrieve list of suggested friends rank on number of mutual friends
    results = client.query("CALL GetSuggestedFriends(#{self.id})")
    results.each do |result|
      local_user = User.friendly.find(result['id'])      
      @friends_suggestion << local_user if not @friends_suggestion.include?(local_user)
    end
    
    @friends_suggestion
  end

  # return true if self user is follow by param user
  def is_follow_by?(user)
    number = Follow.where("follower_id = ? and followable_id = ? and status = 1 and blocked = false", user.id, self.id)
    return number.count != 0
  end
  
  # return true if self user is following param user
  def is_following?(user)
    number = Follow.where("follower_id = ? and followable_id = ? and status = 1 and blocked = false", self.id, user.id)
    return number.count != 0
  end

  def is_following_with_pending_request?(user)
    number = Follow.where("follower_id = ? and followable_id = ? and status = 0 and blocked = false", self.id, user.id)
    return number.count != 0
  end

  # Return the number of mutual friends
  def number_mutualfriends(user)    
    myfriends_array = []
    user_friends_array = []

    # MY ARRAY OF FRIENDS
    myfriends = Follow.for_follower(self).select("followable_id")
    myfriends.each do |myfriend|
      myfriends_array << myfriend.followable_id      
    end

    # param <user> ARRAY OF FRIENDS
    user_friends = Follow.for_follower(user).select("followable_id")
    user_friends.each do |f|
      user_friends_array << f.followable_id
    end
    user_friends = Follow.for_followable(user).select("follower_id")
    user_friends.each do |f|
      user_friends_array << f.follower_id
    end

    # ARRAY OF MUTUAL FRIENDS
    mutual_friends_array = myfriends_array & user_friends_array

    return mutual_friends_array.count    
  end
 
  # Return yes if user has no oauth_token or oauth_token is expired
  def is_facebook_oauth_token_expired?
    if self.oauth_token.blank? or self.oauth_expires_at.blank?      
      return true
    else
      if self.oauth_expires_at <= Time.now        
        return true
      else      
        return false
      end
    end
  end

  # Check if user has enough point to unlock a new book 
  def unlock_book!    
    book_to_unlock = self.next_book
    if book_to_unlock.required_points <= self.points
      book_users = BookUser.new
      book_users.user = self
      book_users.book = book_to_unlock
      book_users.save      
      self.add_notifications("Congratulations! You have unlocked <strong><i>#{book_to_unlock.name}</i></strong>. ", 
                            "Félicitations! Tu as débloqué <strong><i>#{book_to_unlock.name}</i></strong>. ",
                            self, nil, book_to_unlock)      
    end
  end

  # Return last book unlocked
  def current_book
    book = self.books.order("level DESC").first    
    return book
  end

  def next_book
    book = self.books.order("level DESC").first
    book = Book.find_by level: (book.level + 1)
    return book
  end

  def next_book_progression
    curbook = self.current_book
    nextbook = self.next_book
    book_diff = nextbook.required_points - curbook.required_points
    user_diff = self.points - curbook.required_points
    progression_percentage = (100 * user_diff) / book_diff
    return progression_percentage
  end


  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
