require 'spec_helper'
describe 'CreditCard' do
	describe 'validation' do
		it 'passes if card passes Luhn-10' do
			CreditCard.new('Test', '4111111111111111').valid?

		end

		it 'fails if card does not pass Luhn-10' do
			CreditCard.new('Test', '1234567890123456').valid?
		end
	end
end