require 'ext/p'

Dir[Rails.root.join('lib', 'out', '*', 'plugin.rb')].each { |f| 
  dot = f.split('/')[-2][0]

  if dot != '.'
    require f 
  end
}