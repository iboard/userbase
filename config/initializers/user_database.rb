if File::exists?("#{Rails.root}/config/user_db.yml")
  USER_DATABASE=YAML.load_file("#{Rails.root}/config/user_db.yml")[Rails.env]
else
  USER_DATABASE={ 'use_remote_database' => false }
end
