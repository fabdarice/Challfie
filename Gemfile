source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'
gem 'devise'

gem 'thin'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem "paperclip", "~> 4.1"

gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', branch: 'bootstrap3'

gem "font-awesome-rails"

gem 'omniauth-facebook'

# Facebook Graph
gem "koala", "~> 1.10.0rc"

gem 'will_paginate', '~> 3.0'


gem 'sunspot_rails'
gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development


gem 'friendly_id', '~> 5.0.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

gem "acts_as_follower"

gem 'rails3-jquery-autocomplete'

gem 'progress_bar'

gem 'acts_as_votable', '~> 0.10.0'


group :development, :test do
  # Use sqlite3 as the database for Active Record
	gem 'mysql2'
  # For Email testing in development mode
  gem 'mailcatcher'
end

group :production do
  gem 'pg', '~> 0.17.1'

  #To Digest Assets on Heroku
  gem 'rails_12factor'
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
