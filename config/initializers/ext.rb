require 'ext/p'

Dir[Rails.root.join('lib', 'out', '*', 'plugin.rb')].each { |f| require f }