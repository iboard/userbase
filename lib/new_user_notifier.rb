class NewUserNotifier < Struct.new( :user_id, :subject, :email )
   
    def perform
      user = User.find(user_id)
      UserMailer::notify_admin_about_new_user(user,subject,email).deliver
    end
    
end