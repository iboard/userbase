class Authentication < ActiveRecord::Base
  belongs_to :user
  
  def provider_name
    case provider 
    when 'open_id' 
      "OpenID"
    when 'thirty_seven_signals' 
      '37 Signals'
    else
      provider.titleize
    end
  end
end
