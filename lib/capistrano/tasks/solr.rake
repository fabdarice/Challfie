namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do 
    execute "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    execute "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    execute "rm -rf #{shared_path}/solr/data"
    start
    execute "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end