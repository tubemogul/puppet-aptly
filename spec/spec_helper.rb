require 'puppetlabs_spec_helper/module_spec_helper'

# coveralls.io integration
if ENV['COVERAGE'] == 'yes'
  require 'coveralls'
  Coveralls.wear!
end
