type Dataset

    dataMatrix::Matrix
    getEdge::Function
    edgeSize::Function
	function Dataset(dataMatrix::Matrix)
		this = new()
        this.dataMatrix = dataMatrix
        this.getEdge = function getEdge(n)
            return dataMatrix[Int64(n),:]
        end
        this.edgeSize = function edgeSize()
            return length(dataMatrix[:,1])
        end
		return this
	end

end
