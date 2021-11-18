# Parent class for patronictl providers
class Puppet::Provider::Patronictl < Puppet::Provider
  initvars

  class << self
    attr_accessor :path
    attr_accessor :config
  end

  def self.patronictl(args, options = {})
    cmd = [@path] + ['-c', @config] + args
    default_options = { combine: true, override_locale: false, custom_environment: { 'LC_ALL' => 'en_US.utf8' } }
    ret = execute(cmd, default_options.merge(options))
    ret
  end

  def patronictl(*args)
    self.class.patronictl(*args)
  end

  def self.type_properties
    resource_type.validproperties.reject { |p| p.to_sym == :ensure }
  end

  def type_properties
    self.class.type_properties
  end

  def self.flatten_hash(hash)
    hash.each_with_object({}) do |(k, v), h|
      if v.is_a? Hash
        flatten_hash(v).map do |h_k, h_v|
          h["#{k}.#{h_k}"] = h_v
        end
      else
        h[k] = v
      end
    end
  end
end
