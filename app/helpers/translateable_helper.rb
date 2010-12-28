module TranslateableHelper
  
  # Show and link translations of this translateable
  def language_links(translateable)
    
    translations = translateable.translations.map { |t| t.locale.to_sym }

    I18n.available_locales.map { |locale|
      if translateable.locale.to_s == locale.to_s
        link_to(
            image_tag( "/images/#{locale}.jpg", :class => "locale_img_translated" ),
            translateable )  # : "locale_img_not_translated"
        
      elsif translation = translateable.translations.where(:locale => locale).first
        link_to(
          image_tag("/images/#{locale}.jpg", :class => "locale_img_translated"),
          eval("#{translateable.class.to_s.humanize}").find(translation.translated_id)  # : "locale_img_not_translated"
        )
      else
        if can? :edit, translateable
          link_to( image_tag("/images/#{locale}.jpg", :class => "locale_img_not_translated"),
                 create_translation_path(translateable.class.to_s.humanize,translateable.id,locale),
                 :confirm => t(:are_you_sure, :what => t(:create_a_translation))
               )
        else
          image_tag("/images/#{locale}.jpg", :class => "locale_img_not_translated")
        end
      end          
    }.join(" ").html_safe
  end
  
end