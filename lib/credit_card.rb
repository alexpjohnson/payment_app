class CreditCard
	def initialize(name, number)
		@cardholder = name
		@card_number = number
	end

	attr_reader :cardholder, :card_number

	def valid?
		return false unless card_number  =~ /^\d+$/
		arr = card_number.split('').reverse.each_with_index.map {|d, index| (index.odd? ? 2*(d.to_i) : d.to_i)}
	  (arr.join.split('').inject(0) {|total, d| total + d.to_i}) % 10 == 0
	end
end