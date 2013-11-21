require 'spec_helper'

describe 'User' do
	describe 'add_transaction' do
		before(:each) do
			@actor = User.new('Frank')
			@target = User.new('Jimbo')
		end
		it 'should say the actor paid the target' do
			@actor.add_transaction(@actor.name, @target.name, "5.00", 'test')
			@actor.transactions[0].should == "You paid Jimbo $5.00 for test"
		end

		it 'should say the target received payment' do
			@target.add_transaction(@actor.name, @target.name, "5.00", 'test')
			@target.transactions[0].should == "Jimbo paid you $5.00 for test"
		end

		it 'should increase the target balance' do
			@target.add_transaction(@actor.name, @target.name, "5.00", 'test')
			@target.balance.should == 5.0
		end
	end
	
	describe 'add_card' do
		it 'should add a credit card object' do
			actor = User.new('Frank')
			actor.credit_card.should == nil
			card = CreditCard.new(actor.name, '4111111111111111')
			actor.add_card(card)
			actor.credit_card.should == card
		end
	end
end