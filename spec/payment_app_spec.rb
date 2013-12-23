require 'spec_helper'

describe 'PaymentApp' do
	describe 'initialize' do
		it 'should create a users hash and credit card hash' do
			p = PaymentApp.new
			p.credit_cards.should be_empty
			p.users.should be_empty
		end
	end

	describe 'parse_line' do
		describe 'user' do
			before(:each) do
				@app = PaymentApp.new
			end
			it 'should create a new user' do
				@app.parse_line('user Frank')
				@app.users['Frank'].name.should == 'Frank'
			end

			it 'should return an error message if name less than 4 characters' do
				output = capture_stdout do
					@app.parse_line('user Jim')
				end
				output.chomp.should == 'User name needs to be between 4 and 15 characters and allows underscores and dashes'
			end

			it 'should return an error message if name greater than 15 characters' do
				output = capture_stdout do
					@app.parse_line('user ABCDEFGHIJLKMNOP')
				end
				output.chomp.should == 'User name needs to be between 4 and 15 characters and allows underscores and dashes'
			end
		end
	end

	describe 'add' do
		before(:each) do
			@app = PaymentApp.new
			@app.parse_line('user Frank')
		end
		it 'should add a credit card to a user if the card is valid' do
			@app.parse_line('add Frank 4111111111111111')
			@app.users['Frank'].credit_card.cardholder.should == 'Frank'
			@app.credit_cards['4111111111111111'].cardholder.should == 'Frank'
		end

		it 'should return an error if a card is not valid' do
			output = capture_stdout do
				@app.parse_line('add Frank 4111111111111110')
			end
			output.chomp.should == 'This card is invalid'
		end

		it 'should return an error if a user does not exist' do
			output = capture_stdout do
				@app.parse_line('add Jim 4111111111111111')
			end
			output.chomp.should == 'This user does not exist'
		end

		it 'should return an error if that card already exists for another user' do
			output = capture_stdout do
				@app.parse_line('add Frank 4111111111111111')
				@app.parse_line('user Jimbo')
				@app.parse_line('add Jimbo 4111111111111111')
			end
			output.chomp.should == 'That card has already been added by another user, reported for fraud!'
		end

		it 'should return an error if a card is longer than 19 characters' do
			output = capture_stdout do
				@app.parse_line('add Frank 99999999999999999999')
			end
			output.chomp.should == 'This card number is too long'
		end
	end

	describe 'pay' do
		before(:each) do
			@app = PaymentApp.new
			@app.parse_line('user Frank')
			@app.parse_line('user Jimbo')
		end

		it 'should add a transaction to the actor of a payment' do
			@app.parse_line('add Frank 4111111111111111')
			@app.parse_line('pay Frank Jimbo $5.05 test')
			@app.users['Frank'].transactions.length.should == 1
		end

		it 'should add a transaction to the target of a payment' do
			@app.parse_line('add Frank 4111111111111111')
			@app.parse_line('pay Frank Jimbo $5.05 test')
			@app.users['Jimbo'].transactions.length.should == 1
		end

		it 'should throw an error if a user does not have a credit card' do
			output = capture_stdout do
				@app.parse_line('pay Frank Jimbo $5.05 test')
			end
			output.chomp.should == 'This user does not have a credit card'
		end

	end

	describe 'balance' do
		it 'should print a user\'s balance' do
			@app = PaymentApp.new
			@app.parse_line('user Frank')
			output = capture_stdout do
				@app.parse_line('balance Frank')
			end
			output.chomp.should == '$0.00'
		end
	end

	describe 'feed' do
		it 'should print out a user\'s transactions' do
			@app = PaymentApp.new
			@app.parse_line('user Frank')
			@app.parse_line('user Jimbo')
			@app.parse_line('add Frank 4111111111111111')
			@app.parse_line('pay Frank Jimbo $5.00 test')
			output = capture_stdout do
				@app.parse_line('feed Frank')
			end
			output.chomp.should == 'You paid Jimbo $5.00 for test'
		end
	end

  describe 'comment' do
    it 'should accept a comment on a payment'
			@app = PaymentApp.new
			@app.parse_line('user Frank')
			@app.parse_line('user Jimbo')
			@app.parse_line('add Frank 4111111111111111')
			@app.parse_line('pay Frank Jimbo $5.00 test')
			output = capture_stdout do
				@app.parse_line('comment Frank Jimbo 1 Thanks ')
      end
      @app.users['Jimbo'].comments[1].length.should == 1
  end
	describe 'other command' do
		it 'should output an error for a mistyped command' do
			@app = PaymentApp.new
			output = capture_stdout do
				@app.parse_line('abcd Jimbo')
			end
			output.chomp.should == 'This is not a valid command'
		end

		it 'should output an error if a command has no target' do
			@app = PaymentApp.new
			output = capture_stdout do
				@app.parse_line('balance')
			end
			output.chomp.should == 'This is not a valid command'
		end
	end
end

def capture_stdout &block
  old_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  block.call
  fake_stdout.string
ensure
  $stdout = old_stdout
end
