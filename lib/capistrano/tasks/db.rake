namespace :db do
  desc "reset database then repopulate with seeds.rb"	
  task :reset do
  	on roles(:app) do
  		within current_path do
  			with rails_env: fetch(:rails_env, 'production') do
    			execute :bundle, 'exec', :rake, 'db:reset'
    		end
    	end
   end
  end

  desc "Launch rake db:seed (seeds.rb) on production server" 
  task :seed do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env, 'production') do
          execute :bundle, 'exec', :rake, 'db:seed'
        end
      end
   end
  end
end