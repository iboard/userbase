class Translation < ActiveRecord::Base
  
  belongs_to :translateable, :polymorphic => true
  
  before_destroy :prepare_remove_sibling
  after_destroy  :remove_sibling
  
  scope :translations_of, lambda { |type,id|
    where(:translateable_type => type,:translateable_id   => id)
  }
  
  private
  def prepare_remove_sibling
    @remove_translations = Translation.where( :translateable_type => self.translateable_type,
                                              :translateable_id => self.translated_id,
                                              :locale => self.translateable.locale)
  end
  
  def remove_sibling
    @remove_translations.delete_all if @remove_translations
  end
  
end
