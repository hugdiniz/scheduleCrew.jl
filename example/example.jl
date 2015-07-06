#including the code
#cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/src/core")
include("../src/core/core.jl")
#cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/src/scheduleCrewProblem/")
#include("scheduleCrewProblem.jl")
include("../src/scheduleCrewProblem/scheduleCrewProblem.jl")

cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/example")

function readDataSet(path)
    return readcsv(path)
end

dataMatrix = readDataSet("datasetModified/datasetModifiedMin3.csv")
dataset = Dataset(dataMatrix)
numberCrews= 40
requiredPenalty = 100000
limitConsectuiveMinutes = 720
extraMinutesCost = 2
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

staticVars = StaticVars(numberCrews,requiredPenalty,limitConsectuiveMinutes,extraMinutesCost)
model = ScheduleCrewModel(edgeCost,dataset,staticVars)
tabuSearch = TabuSearch()
scheduleSolution = ScheduleSolution()

experiment = Experiment(scheduleSolution,tabuSearch,model)

es = experiment.runExperiment()
experiment.solution.cost()
#ids = getBestCrewEdge(model,1,experiment.solution)
#println("first:",initSolution[ids[1],:])
#experiment.solution.setCrewId(ids[1],ids[2])
#println("second:",initSolution[ids[1],:])
#localSearch = LocalSearch(model)
#localSearch.runMetaheuristic(experiment.solution)
