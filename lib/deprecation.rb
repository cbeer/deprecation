require 'deprecation/behaviors'
require 'deprecation/reporting'
require 'deprecation/method_wrappers'
require 'active_support/concern'
require 'deprecation/core_ext/module/deprecation'

module Deprecation
  extend ActiveSupport::Concern

  def deprecation_horizon= horizon
    @deprecation_horizon = horizon
  end

  def deprecation_horizon
    @deprecation_horizon
  end

  def silenced
    @silenced
  end

  def silenced= bool
    @silenced = bool
  end

  def debug
    @debug
  end

  def debug= bool
    @debug = bool
  end

  included do
    class << self
    end

    # By default, warnings are not silenced and debugging is off.
    self.silenced = false
    self.debug = false
  end
end

