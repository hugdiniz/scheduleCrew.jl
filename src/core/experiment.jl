type Experiment
	  solution::Solution
    runExperiment::Function
    model::Model
    metaheuristic::Metaheuristic
    function Experiment(solution::Solution,metaheuristic::Metaheuristic,model::Model)
        this = new()
        this.solution = solution
        this.model = model
        this.metaheuristic = metaheuristic
        this.runExperiment = function runExperiment()
          solution.initSolution = solution.createInitSolution(model)
          solution = metaheuristic.runMetaheuristic(solution)
          return solution
        end
		return this
	end
end
