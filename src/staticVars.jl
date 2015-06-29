type StaticVars
    numberCrews::Int
    requiredPenalty::Int64

	function StaticVars(numberCrews,requiredPenalty)
		this = new()
        this.numberCrews = numberCrews
        this.requiredPenalty = requiredPenalty
		return this
	end

end

