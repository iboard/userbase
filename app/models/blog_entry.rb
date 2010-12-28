class BlogEntry < ActiveRecord::Base
  belongs_to :blog_entry, :polymorphic => true
end
