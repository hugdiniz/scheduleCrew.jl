type StaticVars
    numberCrews::Int
    requiredPenalty::Int64
    limitConsectuiveMinutes::Int64
    extraMinutesCost::Int64

	function StaticVars(numberCrews,requiredPenalty,limitConsectuiveMinutes,extraMinutesCost)
		this = new()
        this.numberCrews = numberCrews
        this.requiredPenalty = requiredPenalty
        this.limitConsectuiveMinutes = limitConsectuiveMinutes
        this.extraMinutesCost = extraMinutesCost
		return this
	end

end

