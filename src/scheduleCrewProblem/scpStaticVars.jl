type StaticVars
    numberCrews::Int
    requiredPenalty::Int64
    limitConsectuiveMinutes::Int64
    extraMinutesCost::Int64
    costForCrew::Int64

	function StaticVars(numberCrews,requiredPenalty,limitConsectuiveMinutes,extraMinutesCost,costForCrew = 100)
		this = new()
        this.numberCrews = numberCrews
        this.requiredPenalty = requiredPenalty
        this.limitConsectuiveMinutes = limitConsectuiveMinutes
        this.extraMinutesCost = extraMinutesCost
        this.costForCrew = costForCrew
		return this
	end

end

