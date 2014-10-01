namespace :solr do
  desc "start solr"
  task :start do 
    on roles(:app) do    
      execute "cd #{current_path} && RAILS_ENV=PRODUCTION bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
    end
  end
  
end