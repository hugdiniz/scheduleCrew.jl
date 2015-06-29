abstract Model

type ScheduleCrewModel <: Model
	data::Dataset
	edgeCost::Function
    crews::Array
    numberCrews::Int
    staticVars::StaticVars
	function ScheduleCrewModel(edgeCost, data::Dataset,staticVars::StaticVars,crews = null)
		this = new()
        this.data = data
        this.staticVars = staticVars
        this.edgeCost = function realEdgeCost(edge,crew::Crew)
           return edgeCost(this,edge,crew)
        end
        this.crews = Array(Crew, numberCrews)
        if (crews == null)
            for i = 1:numberCrews
                this.crews[i] = Crew(i,this)
            end
        end
		return this
	end

end
