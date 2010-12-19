class NewCommentNotifier < Struct.new( :comment_id )
   
    def perform
      UserMailer::notify_owner_about_comment(comment_id).deliver
    end
    
end
