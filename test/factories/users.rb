# This will guess the User class
Factory.define :user do |u|
   u.id         1
   u.email      'admin@domain.com'
   u.nickname   'Administrator'
   u.roles_mask -1
   u.password   "secret"
   u.password_confirmation "secret"
end
