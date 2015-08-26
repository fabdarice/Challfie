source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
gem 'devise'

# Use sqlite3 as the database for Active Record
gem 'mysql2'

gem 'thin'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
#gem 'jquery-ui-rails'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# to handle image
gem "paperclip", "~> 4.1"


gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', branch: 'bootstrap3'

gem "font-awesome-rails"

# to include Facebook
gem 'omniauth-facebook'

# Facebook Graph
gem "koala", "~> 1.10.0rc"

# TO handle pagination
gem 'will_paginate', '~> 3.0'

# Search Engine - To search for users in the database
gem 'sunspot_rails', '~> 2.1.1'
gem 'sunspot_solr', '~> 2.1.1' # optional pre-packaged Solr distribution for use in development

# have friendly id URL
gem 'friendly_id', '~> 5.0.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

# to handle friends - followers and following
gem "acts_as_follower"

gem 'rails3-jquery-autocomplete'

gem 'progress_bar'

# to handle vote - approve and reject
gem 'acts_as_votable', '~> 0.10.0'


# human verification
gem "recaptcha", :require => "recaptcha/rails"

# to deploy the website on the server
gem 'capistrano', '~> 3.2.1'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rvm', github: "capistrano/rvm"

# to handle auto detect language based on HTTP ACCEPT
gem 'http_accept_language'

# to detect the browser the user is using
gem "browser"

# to use cron to set up daily selfie
gem "whenever"

# to customize how a model will be serialize (for Challfie API)
gem 'active_model_serializers'


# Gem to send iOS Push Notifications
gem 'houston'

# Gem to send Android Push Notifications
gem 'rails-push-notifications', '~> 0.2.0'

# To run background task like ios Notifications
gem 'delayed_job_active_record'
gem "daemons"

# To analyse performance of the rails app
gem 'newrelic_rpm'


group :development, :test do  
  # For Email testing in development mode
  gem 'mailcatcher'
  gem "bullet"

end

group :production do
	gem 'postmark-rails'
	gem 'aws-sdk'
end


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
