class NewPostingNotifier < Struct.new( :posting_id, :subject, :email )
   
    def perform
      posting = Posting.find(posting_id)
      UserMailer::notify_admin_about_new_posting(posting,subject,email).deliver
    end
    
end