namespace :paperclip do
  desc "build missing paperclip styles"
  task :refresh_missing_style do
    on roles(:app) do
    	within current_path do
        with rails_env: fetch(:rails_env, 'production') do
          info "Refreshing missing paperclip styles"
          execute :bundle, 'exec', :rake, 'paperclip:refresh:missing_styles'
 		  end
 		end       
    end
  end

  desc "build missing paperclip styles"
  task :refresh_selfie do
    on roles(:app) do
    	within current_path do
        with rails_env: fetch(:rails_env, 'production') do      
          execute :bundle, 'exec', :rake, 'paperclip:refresh CLASS=Selfie'
 		  end
 		end       
    end
  end
  
end