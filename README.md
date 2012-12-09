```ruby
module DeprecatedModule
  extend Deprecation

  def asdf

  end

  deprecation_deprecate :asdf

  def silence_asdf_warning
     Deprecation.silence(DeprecationModule) do
       asdf
     end
  end
end
```