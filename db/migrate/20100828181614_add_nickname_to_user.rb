class AddNicknameToUser < ActiveRecord::Migration
  
  def self.connection 
    User.connection 
  end
  

  def self.up
    add_column :users, :nickname, :string
    
    
    User.reset_column_information
    User.all.each do |u|
      u.nickname ||=  u.email.split(/\@|\./)[0..1].join(" ")
      u.save
    end
  end

  def self.down
    remove_column :users, :nickname
  end
end
