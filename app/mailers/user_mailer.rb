class UserMailer < ActionMailer::Base
  default :from => DEFAULT_MAIL_FROM
  
  def notify_admin_about_new_posting(posting,subject,email)
    @posting = posting
    @notify_subject = subject
    @posting.assets.each do |asset|
      attachments[asset.asset_file_name] = File.read("#{Asset::ASSET_PATH}/#{asset.id}/original/#{asset.asset_file_name}")
    end
    mail(:to => "Administrator <#{email}>", :subject => subject)
  end
  
  def notify_admin_about_new_user(user,subject,email)
    @user = user
    @notify_subject = subject
    mail( :to => "Administrator <#{email}>", :subject => subject)
  end
  
  def notify_owner_about_comment(comment_id)
    @comment = Comment.find(comment_id, :include => [:commentable,:user])
    mail( :to => "#{@comment.commentable.user.nickname} <#{@comment.commentable.user.email}>", 
          :from => "#{@comment.user.nickname} <#{@comment.user.email}>",
          :subject => t(:your_entry_was_commented, :appname => APPLICATION_CONFIG['name'])
        )
  end

end
