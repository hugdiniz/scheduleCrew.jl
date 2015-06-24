cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/example")
function readDataSet(path)
    return readcsv(path)
end

dataMatrix = readDataSet("datasetModified/datasetModified.csv")
dataset = Dataset(dataMatrix)
numberCrews= 20



function costFunction(edge,crew::Crew)
    return crew.workTimes
end


model = Model(costFunction,dataset,numberCrews)
tabuSearch = TabuSearch()
scheduleInitSolution = ScheduleInitSolution()

experiment = Experiment(scheduleInitSolution,tabuSearch,model)
