require 'houston'
class User < ActiveRecord::Base

  include ActionView::Helpers::SanitizeHelper
  #attr :username, :email, :firstname, :lastname, :avatar, :provider, :uid, :location, :from_mobileapp, 
  #:from_facebook, :facebook_picture, :username_activated, :locale, :blocked, 

  before_save :ensure_authentication_token
  before_destroy :delete_association
  after_create :set_initial_daily_challenge

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
    text :lastname
    text :email
    boolean :blocked
  end  

  acts_as_voter
  
  acts_as_followable
  acts_as_follower

  attr_accessor :login      

  validates :username,
            :uniqueness => { :case_sensitive => false }

  validates_presence_of :firstname, :lastname, :email, :username
  validates_length_of :username, within: 2..15

  validates_format_of :username, with: /\A[a-zA-Z\d]+\z/, 
                      message: I18n.translate('sign_in.error_username_format')                     

  validates :email,
            format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: I18n.translate('sign_in.error_email_format') }

  has_one :facebook_info, dependent: :destroy
  belongs_to :daily_challenge
  has_many :selfies, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :books, :through => :book_users
  has_many :book_users
  
  has_many :devices, dependent: :destroy

  has_many :matchups, :through => :matchup_users
  has_many :matchup_users

  has_attached_file :avatar, 
                    :styles => {:thumb => "", :medium => "" }, 
                    :convert_options => { :medium => Proc.new { |instance| instance.avatar_dimension }, 
                                          :thumb => Proc.new { |instance| instance.avatar_dimension(75) } },
                    :default_url => "/assets/missing_user.png"                    
  
  validates_attachment :avatar,
            :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
            :size => { :in => 0..5.megabytes }  

  def set_initial_daily_challenge    
    self.daily_challenge =  DailyChallenge.last   
    self.save
  end

  def avatar_dimension(size=300)
    dimensions = Paperclip::Geometry.from_file(avatar.queued_for_write[:original].path)
    min = dimensions.width > dimensions.height ? dimensions.height : dimensions.width
    size = min if min < size
    "-gravity Center -crop #{min}x#{min}+0+0 +repage -resize #{size}x#{size}^"
  end            

  def not_from_facebook?
    !self.from_facebook
  end

  def self.find_for_facebook_oauth(auth, from_mobileapp, timezone)        

    # to replace his actual email with @facebook.com email to fix the problem of having a doublon
    user = self.where(email: auth[:info][:email]).first || self.where(provider: auth[:provider], uid: auth[:uid]).first

    if user == nil
      user = User.new
      user.provider = auth[:provider]
      user.uid = auth[:uid]      
      user.email = auth[:info][:email]
      user.password = Devise.friendly_token[0,20]
      user.username = auth[:uid].to_s[0,15]   # assuming the user model has a name
      user.firstname = auth[:info][:first_name]
      user.lastname = auth[:info][:last_name]
      user.facebook_picture = auth[:info][:image].gsub!("http", "https") # assuming the user model has an image
      user.oauth_token = auth[:credentials][:token]
      user.oauth_expires_at = Time.at(auth[:credentials][:expires_at].to_i).utc
      user.from_facebook = true
      user.from_mobileapp = from_mobileapp
      user.username_activated = false   
      user.locale = I18n.locale 
      user.timezone = timezone  if timezone != nil
      user.skip_confirmation!  
    else  
      timezone = user.timezone if timezone == nil
      user.update_attributes(uid: auth[:uid],
                            provider: auth[:provider],
                            oauth_token: auth[:credentials][:token],
                            oauth_expires_at: Time.at(auth[:credentials][:expires_at].to_i).utc,
                            facebook_picture: auth[:info][:image].gsub!("http", "https"),
                            locale: I18n.locale,
                            timezone: timezone) 
    end

    if user.save                                   

      facebook_info = FacebookInfo.find_by(user_id: user.id)            
      if facebook_info == nil
        facebook_info = FacebookInfo.new(facebook_lastname: auth[:info][:last_name],
                                       facebook_firstname: auth[:info][:first_name],
                                       facebook_locale: auth[:extra][:raw_info][:locale])
        facebook_info.user = user
      else
        facebook_info.update_attributes(facebook_lastname: auth[:info][:last_name],
                                       facebook_firstname: auth[:info][:first_name],
                                       facebook_locale: auth[:extra][:raw_info][:locale])
      end      
      facebook_info.save

      # IF FIRST TIME REGISTRATION FROM FACEBOOK 
      if user and BookUser.where(user_id: user.id).count == 0
        first_level_book = Book.find_by level: 1
        BookUser.where(user_id: user.id, book_id: first_level_book.id).first_or_create!                
      end

      return user
    else  
      return nil
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

  def show_profile_picture(size_type)
    if self.facebook_picture.blank?      
        return self.avatar.url(:thumb) if size_type == "thumb"
        return self.avatar.url(:medium) if size_type == "medium"
    else
      if self.avatar.blank?
        self.facebook_picture
      else            
        return self.avatar.url(:thumb) if size_type == "thumb"
        return self.avatar.url(:medium) if size_type == "medium"
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

  # If status = 0 : Return list of users self is following with pending request
  # If status = 1 : Return list of users self is following
  # If status = 2 : Return list of users self is following but has been removed/unfollowed
  def following(status)
    user_following = Follow.where('status = ? and follower_id = ? and blocked = false', status, self.id);
    following = []
    user_following.each do |f|
      user = User.friendly.find(f.followable_id)
      following << user if user.blocked == false
    end
    following = following.sort_by{|u| u.username.downcase}
  end

  def all_following    
    user_following = Follow.where('(status = 0 or status = 1) and follower_id = ? and blocked = false', self.id);
    following = []
    user_following.each do |f|
      user = User.friendly.find(f.followable_id)
      following << user if user.blocked == false
    end
    following = following.sort_by{|u| u.username.downcase}
  end

  # If status = 0 : Return list of pending request
  # If status = 1 : Return list of followers (users who are following you)
  # If status = 2 : Return list of followers that has been unfollowed/removed
  def followers(status)
    user_followers = Follow.where('status = ? and followable_id = ? and blocked = false', status, self.id);
    followers = []
    user_followers.each do |f|
      user = User.friendly.find(f.follower_id)
      followers << user if user.blocked == false
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

  def add_notifications(message_en, message_fr, author, selfie, book, type_notification, matchup)     
    if selfie.blank? || (not selfie.blank? and selfie.hidden == false)
      @notification = self.notifications.build(message_en: message_en, message_fr: message_fr, author: author,
                                               selfie: selfie, book: book, type_notification: type_notification, matchup: matchup)
      
      if @notification.save
        if self.locale == "fr"
          message = message_fr
        else
          message = message_en
        end

        if @notification.comment_mine? or @notification.comment_other? or @notification.selfie_approval? or @notification.friend_request?
          notif_msg = @notification.author.username + message
        else
          notif_msg = message
        end

        # send notification to iOS device & Android Device
        self.delay.send_ios_notification(notif_msg)
        self.delay.send_android_notification(notif_msg)
      end 
    end 
  end

  def send_ios_notification(message)
    # Environment variables are automatically read, or can be overridden by any specified options. You can also
    # conveniently use `Houston::Client.development` or `Houston::Client.production`.
    if Rails.env.production?      
      apn_client = Houston::Client.production
      apn_client.certificate = File.read("#{Rails.root}/config/ios_certificate/apple_push_notification_prod.pem")
    else
      apn_client = Houston::Client.development
      apn_client.certificate = File.read("#{Rails.root}/config/ios_certificate/apple_push_notification_dev.pem")
    end        

    self.devices.where("type_device = 0 and active = true").each do |device|      
      # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
      ios_push_notification = Houston::Notification.new(device: device.token)
      ios_push_notification.alert = strip_tags(message)
      
      # Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
      push_badge_number = self.notifications.where(read: false).count + self.followers(0).count

      ios_push_notification.badge = push_badge_number
      ios_push_notification.sound = "sosumi.aiff"
      ios_push_notification.category = "INVITE_CATEGORY"
      ios_push_notification.content_available = true
      
      #logger.info "Error: #{ios_push_notification.error}." if ios_push_notification.error      
      
      # And... sent! That's all it takes.
      apn_client.push(ios_push_notification)
    end 
  end

  def send_android_notification(message)
    
    app = RailsPushNotifications::GCMApp.find_or_create_by(gcm_key: 'AIzaSyA8FyhMAHUZxWCGgftQv8e6b09dt9d7icw')            
    
    array_of_android_device_token = []

    self.devices.where("type_device = 1 and active = true").each do |device|      
      array_of_android_device_token << device.token
      # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app            
    end 

    if array_of_android_device_token.count != 0 
      notification = app.notifications.create(destinations: array_of_android_device_token, data: { message: strip_tags(message) })           
      # And... sent! That's all it takes.
      app.push_notifications
    end
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
    if !self.uid.blank? and !self.oauth_token.blank?                  
      begin                
        @graph = Koala::Facebook::API.new(self.oauth_token)                   
        facebook_friends = @graph.get_connections("me", "friends")  
        facebook_friends.each do |fb_friend|
          fb_friends_sug = User.find_by uid: fb_friend['id']
          # ADD TO SUGGESTION IF NOT ALREADY FOLLOWING
          @friends_suggestion << fb_friends_sug if not fb_friends_sug.blank? and not self.following?(fb_friends_sug) and fb_friends_sug.blocked == false
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
      @friends_suggestion << local_user if not @friends_suggestion.include?(local_user) and local_user.blocked == false
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
    myfriends = Follow.for_follower(self).select("followable_id").where(status: 1)
    myfriends.each do |myfriend|
      myfriends_array << myfriend.followable_id      
    end

    # param <user> ARRAY OF FRIENDS
    user_friends = Follow.for_follower(user).select("followable_id").where(status: 1)
    user_friends.each do |f|
      user_friends_array << f.followable_id
    end
    user_friends = Follow.for_followable(user).select("follower_id").where(status: 1)
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
    next_books = Book.where("level > ? and visible = true and active = true", self.current_book.level)
    next_books.each do |book_to_unlock|          
      if book_to_unlock.required_points <= self.points
        book_users = BookUser.new
        book_users.user = self
        book_users.book = book_to_unlock
        book_users.save      
        self.add_notifications("Congratulations! You just level up : \"<strong><i>#{book_to_unlock.name}</i></strong>\". ", 
                              "Félicitations ! Tu viens de monter de niveau : \"<strong><i>#{book_to_unlock.name}</i></strong>\". ",
                              self, nil, book_to_unlock, Notification.type_notifications[:book_unlock], nil)      
      end
    end  
  end

  # Return last book unlocked
  def current_book
    book = self.books.where('level > 0 and visible = true and active = true').order("level DESC").first    
    return book
  end

  def next_book    
    book = Book.find_by level: (self.current_book.level + 1)
    return book
  end

  def next_book_progression
    curbook = self.current_book
    nextbook = self.next_book

    if nextbook == nil
      return 100
    end

    book_diff = nextbook.required_points - curbook.required_points
    user_diff = self.points - curbook.required_points
    progression_percentage = (100 * user_diff) / book_diff
    return progression_percentage
  end

  def should_generate_new_friendly_id?
    username_changed?
  end


  def current_rank
    if self.current_book.level < 2
      return "TBD"
    else
      return User.where('points >= ?', self.points).count
    end     
  end

  # Delete assocation that aren't link to has_one or has_many
  def delete_association
    # Delete Follower/Followings form Follows table
    follows_to_delete = Follow.where("followable_id = ? or follower_id = ?", self.id, self.id)
    follows_to_delete.each do |follow|
      follow.destroy
    end

    #Deletes Votes
    votes_to_delete = self.votes
    votes_to_delete.each do |vote|
      vote.destroy
    end

    #Delete Book Users
    self.books.delete_all

    #Delete Matchup Users
    self.matchups.delete_all

    #Delete Permanently Notifications related to that user
    notifications_to_delete = Notification.where(author_id: self.id)
    notifications_to_delete.each do |notification|
      notification.destroy
    end
  end

=begin
# If I ever want to implement Daily Matchup  

  def is_already_in_daily_matchup?
    if self.matchups.last.created_at < Time.zone.now - 36.hours
      return true
    else
      return false
    end

  end

  def find_user_daily_matchups
    user_followers = self.followers(1).where(timezone: self.timezone)
    user_followings = self.following(1).where(timezone: self.timezone)
    
    # If user doesn't have more than 10 following and 10 followers : can't do it
    if user_followers.count < 10 or user_followings < 10
      return nil
    end

    # get user last ten matchups
    user_last_ten_matchups = self.matchups.where(type: 'daily').last(10)

    list_matchup_user_ids = []

    if user_last_ten_matchups.count != 0
      # At least one matchup
      user_last_ten_matchups.each do |matchup|
        list_matchup_user_ids << matchup.users..map{|u| u.id}
      end

      # list of last ten user's you've faced in a matchup
      list_matchup_user_ids = list_matchup_user_ids.uniq

      potential_following_lists = user_followings.where("id not in (?)", list_matchup_user_ids)
      potential_following_lists.shuffle.each do |potential_following|
        if not potential_following.is_already_in_daily_matchup?
          return potential_following
        end
      end

      potential_follower_lists = user_followers.where("id not in (?)", list_matchup_user_ids)
      potential_follower_lists.shuffle.each do |potential_follower|
        if not potential_follower.is_already_in_daily_matchup?
          return potential_follower
        end
      end

      return nil

    else
      # No Matchups Yet
      user_followings.shuffle.each do |potential_following|
        if not potential_following.is_already_in_daily_matchup?
          return potential_following
        end
      end

      user_followers.shuffle.each do |potential_follower|
        if not potential_follower.is_already_in_daily_matchup?
          return potential_follower
        end
      end      

      return nil
    end
  end

  def create_daily_matchup(opponent, type, end_date, challenge)
      daily_matchup = Matchup.new
      daily_matchup.type = type
      daily_matchup.end_date = end_date
      daily_matchup.challenge = challenge
      if daily_matchup.save
        matchup_user1 = MatchupUser.new
        matchup_user1.user = self
        matchup_user1.matchup = daily_matchup

        matchup_user2 = MatchupUser.new
        matchup_user2.user = opponent
        matchup_user2.matchup = daily_matchup

        if matchup_user1.save and matchup_user2.save
          self.add_notifications("Today's daily matchup against <strong>\"#{opponent.username}\"</strong> : \"#{daily_challenge.challenge.description_en}\"", 
                              "Duel du jour contre <strong>\"#{opponent.username}\"</strong> : \"#{daily_challenge.challenge.description_fr}\"",
                              opponent, nil, nil, Notification.type_notifications[:daily_matchup], nil)
          opponent.add_notifications("Today's daily matchup against <strong>\"#{self.username}\"</strong> : \"#{daily_challenge.challenge.description_en}\"", 
                              "Duel du jour contre <strong>\"#{self.username}\"</strong> : \"#{daily_challenge.challenge.description_fr}\"",
                              self, nil, nil, Notification.type_notifications[:daily_matchup], nil)                     
          return true
        else
          return false
        end
      else
        return false
      end
  end
=end  

  def challenge_matchup(opponent, challenge, type_matchup, status, duration)
      matchup = Matchup.new
      matchup.type_matchup = type_matchup      
      matchup.challenge = challenge
      matchup.duration = duration
      if matchup.save
        matchup_creator = MatchupUser.new
        matchup_creator.user = self        
        matchup_creator.matchup = matchup
        matchup_creator.is_creator = true

        matchup_opponent = MatchupUser.new
        matchup_opponent.user = opponent
        matchup_opponent.matchup = matchup
        matchup_opponent.is_creator = false


        if matchup_creator.save and matchup_opponent.save         
          opponent.add_notifications(" challenges you to a <strong>selfie duel</strong> : \"#{challenge.description_en}\"", 
                              " te défie à un <strong>selfie duel</strong> : \"#{challenge.description_fr}\"",
                              self, nil, nil, Notification.type_notifications[:matchup], matchup)                     
          return true
        else
          return false
        end
      else
        return false
      end
  end


=begin
  def pending_matchup
    matchup_users = MatchupUser.where(user_id: self.id, is_creator: false)

    pending_matchups = []
    matchup_users.each do |matchup_user|
      if matchup_user.matchup.status = Matchup.statuses[:pending]
        pending_matchups << matchup_user.matchup
      end
    end    
    return pending_matchups
  end
=end

  def nb_win_matchups
    self.matchups.where("status = ? and winner_id = ?", Matchup.statuses[:ended], self.id).count
  end

  def nb_lose_matchups
    self.matchups.where("(status = ? and winner_id != ?) or status = ?", Matchup.statuses[:ended], self.id, Matchup.statuses[:ended_with_draw]).count
  end

  def get_matchups_stats
    self.nb_win_matchups.to_s + "-" + self.nb_lose_matchups.to_s
  end

  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
