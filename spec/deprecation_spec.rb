require 'spec_helper'

describe Deprecation do
  class DeprecationTest
    extend Deprecation
    self.deprecation_behavior = :raise

    self.deprecation_horizon = 'release 0.1'


    def a
      1 
    end

    deprecation_deprecate :a

    def b
      
    end

    def c

    end

    def d

    end
    
    deprecation_deprecate :c, :d

    def e

    end
    deprecation_deprecate :e => { :deprecation_horizon => 'asdf 1.4' }
  end
  subject { DeprecationTest.new}

  describe "a" do
    it "should be deprecated" do
      expect { subject.a }.to raise_error /a is deprecated/
    end
  end

  describe "b" do
    it "should not be deprecated" do
      expect { subject.b }.not_to raise_error /b is deprecated/
    end
  end

  describe "c,d" do
    it "should be deprecated" do
      expect { subject.c }.to raise_error /c is deprecated/
      expect { subject.d }.to raise_error /d is deprecated/
    end
  end

  describe "e" do
    it "should be deprecated in asdf 1.4" do
      expect { subject.e }.to raise_error /e is deprecated and will be removed from asdf 1.4/
    end
  end
end
