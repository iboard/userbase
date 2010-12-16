class AssetsController < ApplicationController
  
  before_filter  :load_assetable

  # build the asset on the assatable model  
  def new
    @asset = @assetable.assets.build
  end
  
  
  def cancel
  end
  
  private
  
  # parse the requested_uri for _id-params and load the assatable model
  def load_assetable
    resources = params.collect { |p| p[0] if p[0].match /(\S+)_id$/ }.reject { |r| r.nil? }
    resources.each do |r|
      self.instance_variable_set "@"+r.gsub(/_id$/,''), res = eval("#{r.camelize.gsub(/Id/,'')}.find(#{params[r.to_sym]})")
      if r != 'user_id'
        @assetable = res
      else
        @user = User.find(params[:user_id])
      end
    end
    
  end
  
end