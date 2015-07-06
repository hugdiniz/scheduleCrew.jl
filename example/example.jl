#Including core and scheduleCrewProblem
include("../src/core/core.jl")
include("../src/scheduleCrewProblem/scheduleCrewProblem.jl")
cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/example")

#Reading dataset
function readDataSet(path)
    return readcsv(path)
end

dataMatrix = readDataSet("datasetModified/datasetModifiedMin2.csv")
dataset = Dataset(dataMatrix)
#end -- Reading dataset

# Setting staticVars
numberCrews= 5
requiredPenalty = 100000
limitConsectuiveMinutes = 720
extraMinutesCost = 2
#end Setting staticVars

#CostFunction
function edgeCost(solution,edge,crew::Crew)

    model = solution.model
    cost = Int128(edge[5] - edge[4])
    extraMinutes = crew.getExtraMinutes(model,cost)
    cost = cost + extraMinutes*model.staticVars.extraMinutesCost
    workEdge = zeros(Int64,length(solution.initSolution[:,1]))
    edgeIds = findin(solution.initSolution[:,2],crew.id)
    workEdge[edgeIds] = edgeIds
    if(edge[1] != 1)
        index = findprev(workEdge,Int64(edge[1] - 1))

        if length(index) != 0 && index != 0
            lastEdge = model.data.getEdge(workEdge[index])
            if  lastEdge[3] != edge[2]
                cost = cost + model.staticVars.requiredPenalty
               # println("Erro: ",lastEdge[3]," != ",edge[2])
            end
        end
    end

    return cost
end
#End -- CostFunction




function runLocalSearch()
  staticVars = StaticVars(numberCrews,requiredPenalty,limitConsectuiveMinutes,extraMinutesCost)
  model = ScheduleCrewModel(edgeCost,dataset,staticVars)

  localSearch = LocalSearch(model,1000,true)
  scheduleSolution = ScheduleSolution()

  experiment = Experiment(scheduleSolution,localSearch,model)

  solution = experiment.runExperiment()
  return solution.cost()
end

function runTabuSearch()
  staticVars = StaticVars(numberCrews,requiredPenalty,limitConsectuiveMinutes,extraMinutesCost)
  model = ScheduleCrewModel(edgeCost,dataset,staticVars)

  tabuSearch = TabuSearch(model,1000,true)
  scheduleSolution = ScheduleSolution()

  experiment = Experiment(scheduleSolution,tabuSearch,model)

  solution = experiment.runExperiment()
  return solution.cost()
end

