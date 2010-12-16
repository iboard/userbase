#  The submodule 'Assetable' is injected to ActiveResource and provides the method 'can_have_assets'
#  which injects the InstanceModule-methods of this module
#
module Assetables
  
  def self.included(base)
    ActiveRecord::Base.class_eval { include Assetables::Assetable }
    Rails.logger.info( "ASSETABLE LIBRARY LOADED")
  end  
  
  #
  # Module Assetable - ActiveResource Injections
  #
  module Assetable

    def self.included(base)
      base.extend(ClassMethods)
      Rails.logger.info( "ASSETABLE MODULE INCLUDED")
      
    end

    module ClassMethods
      def can_have_assets
        class_eval <<-EOV
          include Assetables::Assetable::InstanceMethods
          has_many   :assets, :as => :assetable, :dependent => :destroy
          accepts_nested_attributes_for :assets, :allow_destroy => true, 
            :reject_if => lambda { |a| 
              a[:title].blank? &&
              a[:description].blank? &&
              a[:asset_file_size].nil?
            } 
        EOV
      end
    end

    module InstanceMethods
    end
    
  end
end

