require 'deprecation'

require 'rspec/expectations'

RSpec::Matchers.define :be_deprecated do |expected|
  match do |actual|
    actual.call
  end
end
