type StaticVars
    numberCrews::Int

	function StaticVars(numberCrews)
		this = new()
        this.numberCrews = numberCrews
		return this
	end

end

