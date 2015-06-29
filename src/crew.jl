type Crew
    workEdge::Array
    id::Int64
    vertex
    addEdge::Function
    removeEdge::Function
    function Crew(id::Int64,model::Model,vertex = null)
        this = new()
        this.id= int(id)
        this.workEdge = zeros(Int32,model.data.edgeSize())
        this.vertex = vertex
        if vertex != null
            this.vertex = Int(vertex)
        end

        this.addEdge = function addEdge(edge)
            this.workEdge[Int64(edge[1])] = edge[3]
        end
        this.removeEdge = function removeEdge(edge)
            this.workEdge[Int64(edge[1])] = 0
        end
        return this
    end
end
