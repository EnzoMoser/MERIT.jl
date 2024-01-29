module Visualize
    function get_slice(image, points, zSlice, axes)

        #Create a boolean array which is True at all the indices where the z-coord
        #is within a 1e-6 tolerance of the desired slice value 
        boolZIdx = abs.(points[:,3] .- zSlice) .< 1e-6
        
        #Create a -radius:resolution:radius x -radius:resolution:radius array.
        #Index each coordinate point with the respective axis
        #Then use the indexes to index into the first matrix and update each location with the intensity
        
        imageSlice =  image[boolZIdx]
        pointsSlice = points[boolZIdx, :]

        intensityGrid = zeros(length(axes[1]), length(axes[2]))
        indexMatrix = zeros(UInt64, size(pointsSlice, 1), 2)
        for i in range(1, size(pointsSlice, 1))
            for j in range(1, 2)
                #Find at which index the x-coord and y-coord is, in the x-axis and y-axis range
                indexMatrix[i, j] = UInt64(collect(searchsorted(axes[j], pointsSlice[i, j]))[1])
            end 
        end

        for i in range(1, size(indexMatrix, 1))
            #Go to the indices for each point and update that location with the intensity/energy from the image matrix
            intensityGrid[length(axes[1]) + 1 - indexMatrix[i, 1], indexMatrix[i, 2]] = imageSlice[i]
        end

        return intensityGrid
    end
end