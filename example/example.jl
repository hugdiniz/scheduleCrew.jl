cd("/home/hugdiniz/Work/Workspace/scheduleCrew.jl/example")
function readDataSet(path)
    return readcsv(path)
end

dataMatrix = readDataSet("datasetModified/datasetModified.csv")
dataset = Dataset(dataMatrix)
numberCrews= 20
model = Model(costCalc,dataset,st)


function costCalc(edge,crew::Crew)


end


