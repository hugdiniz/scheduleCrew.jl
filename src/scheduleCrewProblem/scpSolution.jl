type ScheduleSolution <: Solution
    createInitSolution::Function
    findBestCrew::Function
    cost::Function
    setCrewId::Function
    initSolution::Array
    model::Model
    function ScheduleSolution()
        this = new()
        this.createInitSolution = function createInitSolution(model::Model)
            dataset = model.data
            this.model = model
            #initSolution Matrix:  edgeId -- idCrew
            this.initSolution = cell(dataset.edgeSize(),2)

            for i=1:dataset.edgeSize()
                edge = dataset.getEdge(i)
                bestCrew = findBestCrew(edge,model.crews,model.edgeCost)
                this.initSolution[i,1] = edge[1]
                this.initSolution[i,2] = bestCrew.id

                #adding bestCrew in soluction

                bestCrew.addEdge(edge)
                bestCrew.vertex = edge[3]
                model.crews[bestCrew.id] = bestCrew
            end

            return this.initSolution
        end

        this.findBestCrew = function findBestCrew(edge,crews,edgeCost)
           initVertex =  edge[2]
           bestCrew = null
           for crew in crews
                if bestCrew == null
                    bestCrew = crew
                elseif(bestCrew.vertex == initVertex || crew.vertex == initVertex)
                    bestCrew = crew
                elseif crew.vertex == null
                    bestCrew = crew
                elseif (bestCrew.vertex != initVertex)
                    if(crew.vertex == null || crew.vertex == initVertex)
                        bestCrew = crew
                    end
                end

                if (bestCrew.vertex == initVertex)
                    break;
                end
            end
            return bestCrew
        end

        this.cost = function cost()
            sumEdgeCost = 0
            for i=1:length(this.initSolution[:,1])

                edgeSolution = this.initSolution[i,:]
                edge = this.model.data.getEdge(Int64(edgeSolution[1]))
                crew = this.model.crews[edgeSolution[2]]
                sumEdgeCost = sumEdgeCost + this.model.edgeCost(this,edge,crew)

            end
            uniqueCrew = unique(this.initSolution[:,2])
            sumEdgeCost = sumEdgeCost + (length(uniqueCrew) * this.model.staticVars.costForCrew)
            return sumEdgeCost
        end

        this.setCrewId = function setCrewId(edgeId,crewId)
            this.initSolution[edgeId,2] = crewId
        end

        return this
    end

  function ScheduleSolution(model::Model,initSolution)
      this = ScheduleSolution()
      this.model = model
      this.initSolution = initSolution
      return this
  end

end
