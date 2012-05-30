require 'deprecation/behaviors'
require 'deprecation/reporting'
require 'deprecation/method_wrappers'
require 'active_support/concern'

module Deprecation
  extend ActiveSupport::Concern

  included do
    class << self
      attr_accessor :deprecation_horizon

      # Whether to print a backtrace along with the warning.
      attr_accessor :debug

      attr_accessor :silenced
    end

    # By default, warnings are not silenced and debugging is off.
    self.silenced = false
    self.debug = false
  end

  module ClassMethods
    def deprecate *method_names
      # Declare that a method has been deprecated.
      #   deprecate :foo
      #   deprecate :bar => 'message'
      #   deprecate :foo, :bar, :baz => 'warning!', :qux => 'gone!'
      deprecate_methods(self, *method_names)
    end
  end
end

