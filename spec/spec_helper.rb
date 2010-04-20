$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sonar-zimbra-pull-connector'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end


def sample_mail( filename )
  File.read( File.expand_path(File.join(File.dirname(__FILE__), 'sample_mails', filename)) )
end
