module Beamformer

    function DAS(delayedSignals)
        #return should be of size (1 x 1 x numPoints)
        return sum((sum(delayedSignals, dims=2)).^2, dims=1)   
    end

    function MDAS(delayedSignals)
    end
end