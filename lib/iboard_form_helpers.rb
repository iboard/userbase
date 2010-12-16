module IboardFormHelpers
  
  def self.included(base)
#   ActionView::Helpers::FormBuilder.class_eval { include FormBuilderExtensions }
  end
   
  class ActionView::Helpers::FormBuilder
    def language_select(field)
      select(field, 
             I18n.available_locales.map { |locale| [I18n.translate("locales.#{locale.to_s}"),locale.to_s] })
    end
  end
end