abstract «Experiment»

type ScheduleExperiment <: Experiment
       	
	initFunction::Function
	   	
	function Schedule(initFunction)	
		this = new()
		this.initFunction = initFunction
	       
		return this
	end

end

