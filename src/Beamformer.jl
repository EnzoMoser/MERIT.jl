module Beamformer

    function DAS(delayedSignals)
        #return should be of size (1 x 1 x numPoints)
        sum((sum(delayedSignals, dims=2)).^2, dims=1)[1,1,1] 
    end

    function MDAS(delayedSignals)
    end
end