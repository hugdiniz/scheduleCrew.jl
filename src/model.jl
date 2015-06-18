type Model
	data::Dataset
	costCalc::Function
    crews::Array
    numberCrews::Int
	function Model(costCalc, data::Dataset,numberCrews::Int,crews = null)
		this = new()
        this.data = data
        this.numberCrews = numberCrews
        this.costCalc = costCalc
        this.crews = Array(Crew, numberCrews)
        if (crews == null)
            for i = 1:numberCrews
                this.crews[i] = Crew(i)
            end
        end
		return this
	end

end
