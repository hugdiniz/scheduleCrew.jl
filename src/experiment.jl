type Experiment

	initType::InitSolution
  runExperiment::Function
  model::Model
  metaheuristic::Metaheuristic
	function Experiment(initType::InitSolution,metaheuristic::Metaheuristic,model::Model)
		this = new()
		this.initType = initType
    this.model = model
    this.metaheuristic = metaheuristic
    this.runExperiment = function runExperiment()
      initSolution = initType.createSolution(model)

      return initSolution
    end
		return this
	end

end
