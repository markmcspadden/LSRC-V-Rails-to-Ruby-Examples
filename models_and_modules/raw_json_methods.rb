# app/models/twitter_user
class TwitterUser < ActiveRecord::Base
  include RawJsonMethods
end



# lib/raw_json_methods
require 'json'

module RawJsonMethods
  attr_accessor :raw_json

  # METHOD MISSING ON TOP OF AR:BASE SUCKS!
  def method_missing(method, *args)
    if method.to_s == "raw" || self.class.column_names.include?(method.to_s)
      super
    else
      raw_json_string = self.raw.to_s
    
      if raw_json_string.blank?
        super
      else
        raw_json = JSON.parse(raw_json_string)
        if raw_json.keys.include?(method.to_s)
          raw_json[method.to_s]
        elsif raw_json.keys.include?(method.to_sym)
          raw_json[method.to_sym]
        else
          super
        end
      end
    end
  end
end

