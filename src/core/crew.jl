type Crew
    workEdge::Array
    id::Int64
    vertex
    addEdge::Function
    removeEdge::Function
    getWorkConsecutiveMinutes::Function
    getExtraMinutes::Function
    function Crew(id::Int64,model::Model,vertex = null)
        this = new()
        this.id= Int(id)
        this.workEdge = zeros(Int32,model.data.edgeSize())
        this.vertex = vertex
        if vertex != null
            this.vertex = Int(vertex)
        end

        this.addEdge = function addEdge(edge)
            this.workEdge[Int(edge[1])] = edge[1]
        end
        this.removeEdge = function removeEdge(edge)
            this.workEdge[Int(edge[1])] = 0
        end
        this.getWorkConsecutiveMinutes = function getWorkConsecutiveMinutes(model::Model)
            indexs = find(this.workEdge)
            indexWorkEdges = this.workEdge[indexs]
            if(length(indexWorkEdges) > 0)
                realyWorkEdge = Array(Int64,length(indexWorkEdges),length(model.data.getEdge(1)))

                for i=1:length(indexWorkEdges)
                    realyWorkEdge[i,:] = model.data.getEdge(indexWorkEdges[i])
                end
                workConsecutiveMinutes = 0
                lastEdge = null
                for i=1:length(realyWorkEdge[:,1])
                    edge = realyWorkEdge[i,:]
                    if(lastEdge != null)
                        if(lastEdge[5] - edge[4] > model.staticVars.limitConsectuiveMinutes)
                            workConsecutiveMinutes = 0
                        end
                    end
                    workConsecutiveMinutes = workConsecutiveMinutes + edge[5] - edge[4]
                end
                return workConsecutiveMinutes
            else
                return 0
            end
        end

        this.getExtraMinutes = function getExtraMinutes(model::Model,minutes)
            workConsecutiveMinutes = getWorkConsecutiveMinutes(model)
            if(workConsecutiveMinutes + minutes > model.staticVars.limitConsectuiveMinutes)
                return workConsecutiveMinutes + minutes - model.staticVars.limitConsectuiveMinutes
            else
                return 0
            end
        end

        return this
    end
end

