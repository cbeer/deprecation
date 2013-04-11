```ruby
class DeprecatedModule
  extend Deprecation
  self.deprecation_horizon = 'my_gem version 3.0.0'

  def asdf

  end

  deprecation_deprecate :asdf

  def silence_asdf_warning
     Deprecation.silence(DeprecationModule) do
       asdf
     end
  end
end

DeprecatedModule.new.asdf
DEPRECATION WARNING: asdf is deprecated and will be removed from my_gem version 3.0.0. (called from irb_binding at (irb):18)
=> nil

```
