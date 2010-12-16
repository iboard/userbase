module TranslateableHelper
  
  # Show and link translations of this translateable
  def language_links(translateable)
    # Language of the posting
    rc = t(:language)+": "+ t(('locales.'+translateable.locale).to_sym)
    translations = Translation.translations_of(translateable.class.to_s,translateable.id)
    t = translations.map { |translation|
      target = eval(translation.translateable_type+'.find(translation.translated_id)')
      link_to( t(('locales.'+translation.locale).to_sym), target ) 
    }.join(", ")
    unless t.blank?
      rc += " "+ t(:translations) + ": " + t
    end
    rc.html_safe
  end
  
end