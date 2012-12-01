require "delayed_kiss/version"
require 'delayed_kiss/railtie' if defined?(Rails)

require 'httparty'

module DelayedKiss
  class ConfigurationError < StandardError; end

  mattr_accessor :key
  @@key = nil
  
  mattr_accessor :whiny_config
  @@whiny_config = false
  
  mattr_accessor :config_file
  @@config_file = "config/delayed_kiss.yml"
  
  def self.configure
    yield self
  end

  def self.record(id, event, query_params={})
    Kissmetric.new(@@key, @@whiny_config, @@config_file).
      record(id, event, query_params)
  end

  def self.alias(alias_from, alias_to)
    Kissmetric.new(@@key, @@whiny_config, @@config_file).
      alias(alias_from, alias_to)
  end

  def self.set(id, query_params)
    Kissmetric.new(@@key, @@whiny_config, @@config_file).
      set(id, query_params)
  end

  class Kissmetric
    attr_accessor :key, :whiny_config, :config_file

    include HTTParty
    base_uri "https://trk.kissmetrics.com"

    def initialize(key, whiny_config, config_file)
      @key = key
      @whiny_config = whiny_config
      @config_file = config_file

      raise DelayedKiss::ConfigurationError if @whiny_config && @key.blank?
    end

    def alias(alias_from, alias_to)
      raise ArgumentError.new("you must specify both a from a to value") if alias_from.blank? || alias_to.blank?
      
      query_params = {
        '_n' => alias_to,
        '_p' => alias_from,
        '_t' => Time.now.to_i.to_s,
        '_k' => @key
      }

      self.delay.request_for_api('/a?' + query_params.to_param) unless @key.blank?
    end

    def record(id, event, query_params={})
      raise ArgumentError.new("id can't be blank") if id.blank?
      raise ArgumentError.new("event can't be blank") if event.blank?
      
      query_params.merge!({
        '_n' => event,
        '_p' => id,
        '_t' => Time.now.to_i.to_s,
        '_k' => @key
      })

      self.delay.request_for_api('/e?' + query_params.to_param) unless @key.blank?
    end

    def set(id, query_params)
      raise ArgumentError.new("id can't be blank") if !id || id.blank?
      return if query_params.blank? # don't do anything if we're not setting any values on the identity
      
      query_params.merge!({
        '_p' => id,
        '_t' => Time.now.to_i.to_s,
        '_k' => @key
      })

      self.delay.request_for_api('/s?' + query_params.to_param) unless @key.blank?
    end

  protected

    def request_for_api(request)
      self.class.get(request)
    end
  end
end
