module TranslateableHelper
  
  # Show and link translations of this translateable
  def language_links(translateable)
    
    translations = translateable.translations.map { |t| t.locale.to_sym }

    I18n.available_locales.map { |locale|
      image_tag "/images/#{locale}.jpg", 
        :class => (translations.include?(locale) || locale.to_s == translateable.locale.to_s) ? "locale_img_translated" : "locale_img_not_translated"
    }.join(" ").html_safe
 #    # Language of the posting
 #    rc = t(:locale_icon, :lang => translateable.locale)
 #    translations = Translation.translations_of(translateable.class.to_s,translateable.id)
 #    
 #    logger.info(translations.inspect)
 #    
 #    translations_done = []
 #    t = translations.map { |translation|
 #      target = eval(translation.translateable_type+'.find(translation.translated_id)')
 #      translations_done << translation.locale
 #      link_to( t(:locale_icon, :lang => translation.locale), target ) 
 #    }.join('')
 #   
 #    not_yet_translated = I18n.available_locales - translations_done
 #
 #    nt = not_yet_translated.map { |translation|
 #      t( :locale_icon, :lang => translation)
 #    }.join('')
 #    
 #    (rc+nt).html_safe
  end
  
end