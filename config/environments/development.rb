Challfie::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Email configuration for Mailcatcher (Email testing in development mode)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }


  Paperclip.options[:command_path] = "/usr/local/bin/"

  config.paperclip_defaults = {
    :storage => :s3,   
    :s3_protocol => :https, 
    :url => ":s3_domain_url",
    :path => "/:class/:attachment/:id_partition/:style/:filename",
    :s3_credentials => {
      :bucket => "challfie_dev",
      :access_key_id => ENV['CHALLFIE_AWS_ACCESS_KEY'],
      :secret_access_key => ENV['CHALLFIE_AWS_SECRET_KEY']
    }
  }

  # Bullet Configuration
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.rails_logger = true 
    Bullet.add_whitelist :type => :n_plus_one_query, :class_name => "Selfie", :association => :comments 
    Bullet.add_whitelist :type => :n_plus_one_query, :class_name => "Comment", :association => :user 
  end


end
