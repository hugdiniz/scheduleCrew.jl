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

dataMatrix = readDataSet("datasetModified/datasetModified.csv")
dataset = Dataset(dataMatrix)
numberCrews= 60
requiredPenalty = 1000000


function edgeCost(model,edge,crew::Crew)

    cost = Int128(edge[5] - edge[4])
    edgeIds = find(crew.workEdge)
    if(edge[1] != 1)
        index = findprev(crew.workEdge,Int64(edge[1] - 1))
        if length(index) != 0 && index != 0
            lastEdge = model.data.getEdge(crew.workEdge[index])
            #println("Last: ",lastEdge)
            #println("newEdge: ",edge)
            if  lastEdge[3] != edge[2]
                cost = cost + model.staticVars.requiredPenalty
                #println("Erro: ",lastEdge[3]," != ",edge[2])
            end
        end
    end

    return cost
end

staticVars = StaticVars(numberCrews,requiredPenalty)
model = ScheduleCrewModel(edgeCost,dataset,staticVars)
tabuSearch = TabuSearch()
scheduleSolution = ScheduleSolution()

experiment = Experiment(scheduleSolution,tabuSearch,model)

es = experiment.runExperiment()

#ids = getBestCrewEdge(model,1,experiment.solution)
#println("first:",initSolution[ids[1],:])
#experiment.solution.setCrewId(ids[1],ids[2])
#println("second:",initSolution[ids[1],:])
runMetaheuristic(model,experiment.solution)
