require 'active_support/core_ext/array/extract_options'
require "active_support/core_ext/module/redefine_method"

module Deprecation
  # Declare that a method has been deprecated.
  def self.deprecate_methods(target_module, *method_names)
    options = method_names.extract_options!
    deprecator = options.delete(:deprecator) || self
    method_names += options.keys
    mod = nil

    method_names.each do |method_name|
      if target_module.method_defined?(method_name) || target_module.private_method_defined?(method_name)
        method = target_module.instance_method(method_name)
        target_module.module_eval do
          redefine_method(method_name) do |*args, &block|
            deprecator.warn(target_module, deprecator.deprecated_method_warning(target_module, method_name, options[method_name]), caller)
            method.bind_call(self, *args, &block)
          end
          ruby2_keywords(method_name)
        end
      else
        mod ||= Module.new
        mod.module_eval do
          define_method(method_name) do |*args, &block|
            deprecator.warn(target_module, deprecator.deprecated_method_warning(target_module, method_name, options[method_name]), caller)
            super(*args, &block)
          end
          ruby2_keywords(method_name)
        end
      end
    end
  end
end
