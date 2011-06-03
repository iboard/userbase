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
        can :manage, Gallery
      end 
      
      if user.role? :author
        can :create, Posting
        can :create, Episode
        can :create, Gallery
      end

      # Owner of a posting can manage this posting
      can :manage, Posting do |posting| 
         posting && (posting.user == user || posting.allow_user_to_manage?(user))
      end

      # Owner of a episode can manage this episode
      can :manage, Episode do |episode| 
         episode && (episode.user == user || episode.allow_user_to_manage?(user))
      end

      # Owner of a gallery can manage this gallery
      can :manage, Gallery do |gallery| 
         gallery && (gallery.user == user || gallery.allow_user_to_manage?(user))
      end
      
      
      #
      # For signed in users
      #
      unless user.new_record?
        can :create, Comment
        can :manage, Comment do |comment|
          unless comment.new_record?
            expire = comment.created_at+CONSTANTS['max_time_to_edit_new_comments'].to_i.minutes
            comment && comment.user_id == user.id && (Time.now < expire) # give 15mins to edit new comments
          end
        end
        can :manage, User do |usr|
          usr == user
        end
        can :create, Subscription
        can :manage, Subscription do |subscription|
          user == subscription.user if subscription
        end
      end
      
      can :read, Comment do |comment|
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

      can [:read,:tag], Gallery do |gallery|
        (gallery.nil? && gallery.readable(user.roles_mask & 1).count > 0) ||
        (
          gallery && (gallery.new_record?  || gallery.user == user || gallery.allow_user_to_read?(user))
        )
      end
         
      can :manage, Posting do |posting|
        posting && posting.allow_user_to_manage?(user)
      end

      can :manage, Episode do |episode|
        episode && episode.allow_user_to_manage?(user)
      end
            
      can :manage, Gallery do |gallery|
        gallery && gallery.allow_user_to_manage?(user)
      end
      
    end  

  end
end
