class User
	def initialize(name)
		@name = name
		@credit_card = nil
		@balance = 0.0
		@transactions = Array.new
	end

	attr_reader :name, :credit_card, :balance, :transactions

	def add_transaction(actor, target, amount, reason)
		amount = amount.gsub('$', '')
		if actor == self.name
			@transactions.push("You paid #{target} $#{amount} for #{reason}")
		else
			@transactions.push("#{target} paid you $#{amount} for #{reason}")
			@balance += amount.to_f
		end
	end

	def add_card(card)
		@credit_card = card
	end
end