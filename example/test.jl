function test()
    include("example.jl")
    experiment1 = runLocalSearch()
    arrayResult1 = experiment.metaheuristic.resultsRunMetaheuristc[find(experiment.metaheuristic.resultsRunMetaheuristc)]
    plot(x =[1:length(arrayResult1)],y = arrayResult1)
    include("example.jl")
    println(runTabuSearch())
    experiment2 = runLocalSearch()
    arrayResult2 = experiment2.metaheuristic.resultsRunMetaheuristc[find(experiment2.metaheuristic.resultsRunMetaheuristc)]
    plot(x =[1:length(arrayResult2)],y = arrayResult2)
end
