require 'rspec'
require './lib/credit_card.rb'
require './lib/user.rb'
require './lib/payment_app.rb'
require 'stringio'

RSpec.configure do |c|
	c.mock_with :rspec
	c.color_enabled = true
end