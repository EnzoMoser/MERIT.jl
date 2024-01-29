module Beamformer

    function DAS(delayedSignals)
        processedSignals = sum((sum(delayedSignals, dims=2)).^2, dims=1)   
        #return should be of size (numPoints x 1 x 1)
        return permutedims(processedSignals, (3, 2, 1))

    end
end