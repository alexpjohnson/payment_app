

class PaymentApp
	def initialize
		@users = Hash.new
		@credit_cards = Hash.new
	end

	attr_reader :users, :credit_cards

	def parse_line(line)
		line_arr = line.split(' ')
		command = line_arr[0]
		if line_arr.length > 1
			case(command)
			when 'user'
				user_name = line_arr[1]
				if user_name.length < 16 && user_name.length > 3
					users[user_name] = User.new(user_name)
				else
					puts 'User name needs to be between 4 and 15 characters and allows underscores and dashes'
				end

			when 'add'
				user_name = line_arr[1]
				card_number = line_arr[2]
				if card_number.length <= 19
					if !users[user_name].nil?
						if credit_cards[card_number].nil?
							card = CreditCard.new(user_name, card_number)
							if card.valid?
								users[user_name].add_card(card)
								credit_cards[card_number] = card
							else
								puts 'This card is invalid'
							end
						else
							puts 'That card has already been added by another user, reported for fraud!'
						end
					else
						puts 'This user does not exist'
					end
				else
					puts 'This card number is too long'
				end

			when 'pay'
				actor = line_arr[1]
				target = line_arr[2]
				amount = line_arr[3]
				note = line_arr[4..line_arr.size].join(' ')
				if users[actor].credit_card.nil?
					puts 'This user does not have a credit card'
				else
					users[actor].add_transaction(actor, target, amount, note)
					users[target].add_transaction(actor, target, amount, note)
				end

			when 'balance'
				puts sprintf('$%.2f', users[line_arr[1]].balance)

			when 'feed'
				users[line_arr[1]].transactions.each{|transaction| puts transaction}

			else
				puts 'This is not a valid command'
			end
		else
			puts 'This is not a valid command'
		end
	end

	def run
		if ARGV.empty? #No file passed
			while line = gets.chomp
				if line == 'exit' || line == 'quit'
					exit
				end
				parse_line(line)
			end

		else #Read new file
			ARGF.lines do |line|
				parse_line(line)
			end
		end
	end
end