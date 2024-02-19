"
delayedSignals : The delayed signals

This impliments the Delay-And-Sum (DAS) beamformer.
"

function DAS(delayedSignals::T) where {T}
    #return should be of size (1 x 1 x numPoints)
    sum((sum(delayedSignals, dims=2)).^2, dims=1)[1,1,1] 
end

"
delayedSignals : The delayed signals

This impliments the a generic form of the DAS algorithm
"
function GDAS(delayedSignals::T) where {T}
    #return should be of size (1 x 1 x numPoints)
    sum((sum(delayedSignals, dims=2)).^2, dims=1)[1,1,1] 
end

function MDAS(delayedSignals)
end