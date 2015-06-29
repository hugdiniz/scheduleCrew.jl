cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/example")
function readDataSet(path)
    return readcsv(path)
end

dataMatrix = readDataSet("datasetModified/datasetModified.csv")
dataset = Dataset(dataMatrix)
numberCrews= 20
requiredPenalty = 100000000000



function edgeCost(model,edge,crew::Crew)

    edgeId = findprev(crew.workEdge,Int64(edge[1]))
    cost = (edge[5] - edge[4])
    if edgeId != 0

        lastEdge = model.data.getEdge(edgeId)
        if  lastEdge != edge[2]
            cost = cost + model.staticVars.requiredPenalty
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
