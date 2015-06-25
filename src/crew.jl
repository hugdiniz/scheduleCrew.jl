type Crew
    workTimes::Int64
    id::Int64
    vertex
    function Crew(id::Int64,workTimes = 0, vertex = null)
        this = new()
        this.id= int(id)
        this.workTimes = Int64(workTimes)
        this.vertex = vertex
        if vertex != null
            this.vertex = Int(vertex)
        end
        return this
    end
end
