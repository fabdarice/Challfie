namespace :solr do  
  %w[start stop].each do |command|
    desc "#{command} solr"
    task command do
      on roles(:app) do
        solr_pid = "#{shared_path}/pids/sunspot-solr.pid"
        if command == "start" or (test "[ -f #{solr_pid} ]" and test "kill -0 $( cat #{solr_pid} )")
          within current_path do
            with rails_env: fetch(:rails_env, 'production') do
              execute :bundle, 'exec', 'sunspot-solr', command, "--port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
            end
          end
        end
      end
    end
  end
  
  desc "restart solr"
  task :restart do
    invoke 'solr:stop'
    invoke 'solr:start'
  end
  
  
  desc "reindex the whole solr database"
  task :reindex do
    #invoke 'solr:stop'
    #on roles(:app) do
    #  execute :rm, "-rf #{shared_path}/solr/data"
    #end
    #invoke 'solr:start'
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env, 'production') do
          info "Reindexing Solr database"
          execute :bundle, 'exec', :rake, 'sunspot:solr:reindex'
        end
      end
    end
  end
  
end