require_relative "ruby_outlook/version"
require_relative "ruby_outlook/configuration"
require_relative "ruby_outlook/client"
require_relative "ruby_outlook/error"

module RubyOutlook
  extend Configuration

  # Alias for RubyOutlook::Client.new
  def self.client(options = {})
    RubyOutlook::Client.new(options)
  end

  # Delegate to RubyOutlook::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to RubyOutlook::Client
  def self.respond_to?(method, include_all = false)
    return client.respond_to?(method, include_all) || super
  end
end
