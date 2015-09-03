require 'aws-sdk'

namespace :amazon_s3 do
  desc "Migrate Selfies to Different Folder on Amazon S3"
  task migrate: :environment do
  	s3 = AWS::S3.new(:access_key_id => ENV['CHALLFIE_AWS_ACCESS_KEY'], :secret_access_key => ENV['CHALLFIE_AWS_SECRET_KEY'])
    bucket = s3.buckets["challfie"]
    bucket.objects.each do |object|
      
      if object.key.match(/^selfies/)      	
      	if object.key.scan(/selfies\/photos\/000\/000\/\d+/).first.empty?
      		puts "ERROR FOR " + object.key
      	else
	   		selfie_id = object.key.scan(/selfies\/photos\/000\/000\/\d+/).first.gsub(/selfies\/photos\/000\/000\// , "")
	      	selfie = Selfie.find(selfie_id)
	      	user_id = selfie.user_id

				if object.key.scan(/thumb\/.*/).first
					end_path = object.key.scan(/thumb\/.*/).first
					no_error = true
				elsif object.key.scan(/original\/.*/).first
					end_path = object.key.scan(/original\/.*/).first
					no_error = true
				elsif object.key.scan(/mobile\/.*/).first
					end_path = object.key.scan(/mobile\/.*/).first
					no_error = true
				else
					puts "ERROR FOR " + object.key
					no_error = false
				end

				if no_error == true
	      		new_key = "selfies/photos/" + user_id.to_s + "/" + selfie_id.to_s + "/" + end_path
	      		puts new_key
	      		new_object = bucket.objects[new_key]
      			object.copy_to new_object, {:acl => :public_read}
	      	end
	      end
      end
   end
  end

end
