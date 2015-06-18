type Crew
    workTimes::Int64
    id::Int64
    vertex::Int64
    function Crew(id::Int64,workTimes::Int64 = 0, vertex = null)
        this = new()
        this.id= int(id)
        this.workTimes = workTimes
        if vertex != null
            this.vertex = int(vertex)
        end
        return this
    end
end
