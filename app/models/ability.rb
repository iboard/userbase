class Ability

  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user

    if user.role? :admin
      can :manage, :all  # Admin is god
    else

      #
      # STAFF
      if user.role? :staff
        can :read, User
      end
      
      # current_user can edit her avatar
      can :avatar, User do |usr|
        user == usr
      end
      
      # MODERATORS
      if user.role? :moderator
        can :manage, Posting
        can :manage, Episode
      end 
      
      if user.role? :author
        can :create, Posting
        can :create, Episode
      end

      # Owner of a posting can manage this posting
      can :manage, Posting do |mode,posting| 
         posting && (posting.user == user || posting.allow_user_to_manage?(user))
      end
      
      
      #
      # Comments
      #
      unless user.new_record? # Logged in users aren't new records
        can :create, Comment
        can :manage, Comment do |mode,comment|
          comment && (comment.user == user && comment.created_at && (Time.now()-comment.created_at < (MAX_TIME_TO_EDIT_NEW_COMMENTS*60))) # give 15mins to edit new comments
        end
        can :manage, User do |usr|
          usr == user
        end
      end
      
      can :read, Comment do |mode, comment|
        comment.nil? ||                               # new comments allowed
        (                                             # or
          comment && comment.commentable &&           # owner of comment or commentable
          (
            (comment.commentable.user && comment.commentable.user == user) || 
            (comment.user && comment.user == user) || 
            commentable.allow_user_to_read?(user)
          )
        )
      end

      unless user.new_record? # Logged in users aren't new records
        can :create, Comment
        can :manage, Comment, :user => user
      end      
      
      # Everybody 
      can [:read,:tag], Posting do |posting|
        (posting.nil? && Posting.readable(user.roles_mask & 1).count > 0) ||
        (
          posting && (posting.new_record?  || posting.user == user || posting.allow_user_to_read?(user))
        )
      end
      
      can [:read,:tag], Episode do |episode|
        (episode.nil? && Episode.readable(user.roles_mask & 1).count > 0) ||
        (
          episode && (episode.new_record?  || episode.user == user || episode.allow_user_to_read?(user))
        )
      end

      can :read, Episode do |episode|
        if episode.nil?
          Episode.readable(user.roles_mask).any?
        else
          episode.allow_user_to_read?(user)
        end
      end
      
      can [:read,:tag], Episode do |episode|
         (episode.nil? && Episode.readable(user.roles_mask & 1).count > 0) ||
         (
           episode && (episode.new_record?  || episode.user == user || episode.allow_user_to_read?(user))
         )
      end
      
      can :manage, Posting do |mode,posting|
        posting && posting.allow_user_to_manage?(user)
      end

      can :manage, Episode do |mode,episode|
        episode && episode.allow_user_to_manage?(user)
      end
            
      # Guest
      can :read, Episode do |mode,episode|
        episode && episode.allow_user_to_manage?(user)
      end

      
    end  

  end
end
