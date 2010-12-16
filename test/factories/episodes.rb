# This will guess the Episode class
Factory.define :episode do |u|
   u.id         1
   u.title      'An Episode'
   u.user_id    1
   u.description 'Just another episode'
   u.video_web_url "http://somewhere.video"
   u.video_mobile_url "http://somewhere.esle"
end
