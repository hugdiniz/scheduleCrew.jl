cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/example")
function readDataSet(path)
    return readcsv(path)
end

dataMatrix = readDataSet("datasetModified/datasetModified.csv")
dataset = Dataset(dataMatrix)
numberCrews= 20



function edgeCost(edge,crew::Crew)
    return crew.workTimes
end

staticVars = StaticVars(numberCrews)
model = ScheduleCrewModel(edgeCost,dataset,staticVars)
tabuSearch = TabuSearch()
scheduleSolution = ScheduleSolution()

experiment = Experiment(scheduleSolution,tabuSearch,model)

experiment.runExperiment()
experiment.solution.cost()

getBestCrewEdge(model,1,experiment.solution)
