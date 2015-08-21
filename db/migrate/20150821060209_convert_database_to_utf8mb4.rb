class ConvertDatabaseToUtf8mb4 < ActiveRecord::Migration
  def change
  	# for each table that will store unicode execute:
    execute "ALTER TABLE selfies CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    # for each string/text column with unicode content execute:

    execute "ALTER TABLE selfies CHANGE photo_file_name photo_file_name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE selfies CHANGE photo_content_type photo_content_type VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"    
       
  end
end
