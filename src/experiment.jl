type Experiment

	initFunction::Function

	function Experiment(initFunction)
		this = new()
		this.initFunction = initFunction

		return this
	end

end

type ScheduleExperiment

	initFunction::Function

	function ScheduleExperiment(initFunction)
		this = new()
		this.initFunction = initFunction

		return this
	end

end
