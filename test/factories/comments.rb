# This will guess the Comments class
Factory.define :comment do |u|
   u.id        1
   u.user_id   1
   u.commentable_id 1
   u.commentable_type 'Posting'
   u.comment   'My inteligent comment'
end
