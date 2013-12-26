class User
	def initialize(name)
		@name = name
		@credit_card = nil
		@balance = 0.0
		@transactions = Array.new
    @comments = Hash.new
	end

	attr_reader :name, :credit_card, :balance, :transactions, :comments

	def add_transaction(actor, target, amount, reason)
		amount = amount.gsub('$', '')
		if actor == self.name
			@transactions.push("#{@transactions.length + 1}. You paid #{target} $#{amount} for #{reason}")
		else
			@transactions.push("#{@transactions.length + 1}. #{actor} paid you $#{amount} for #{reason}")
			@balance += amount.to_f
		end
	end

	def add_card(card)
		@credit_card = card
	end

 def add_comment(actor, payment_id, note)
    comm_arr = @comments[payment_id]
    if comm_arr.nil?
        comm_arr =[]
    end
    @comments[payment_id] = comm_arr.push("#{note} - #{actor}")
 end
end
