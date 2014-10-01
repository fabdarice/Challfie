namespace :solr do
  desc "start solr"
  task :start do 
    on roles(:app) do    
      execute "cd #{current_path} && bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids RAILS_ENV=production"
    end
  end

  desc "stop solr"
  task :stop do
    on roles(:app) do     
    execute "cd #{current_path} && bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids RAILS_ENV=production "
    end
  end  

  desc "reindex the whole database"
  task :reindex do
    on roles(:app) do  
      stop
      run "rm -rf #{shared_path}/solr/data"
      start
      run "cd #{current_path} && RAILS_ENV=production bundle exec rake sunspot:solr:reindex"
    end  
  end
  
end