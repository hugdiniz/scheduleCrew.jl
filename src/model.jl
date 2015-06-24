type Model
	data::Dataset
	costFunction::Function
    crews::Array
    numberCrews::Int
	function Model(costFunction, data::Dataset,numberCrews::Int,crews = null)
		this = new()
        this.data = data
        this.numberCrews = numberCrews
        this.costFunction = costFunction
        this.crews = Array(Crew, numberCrews)
        if (crews == null)
            for i = 1:numberCrews
                this.crews[i] = Crew(i)
            end
        end
		return this
	end

end
