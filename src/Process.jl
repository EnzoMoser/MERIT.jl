module Process
    include("Utilities.jl")
    #TODO: Impliment a new delay_signal for the time domain. 

    function delay_signal(signal::Matrix{ComplexF64}, delays::Matrix{Float64}, frequencies::Matrix{Float64})
        #Assuming signals are complex (i.e in the frequency domain)
        #Signals will be of size (numFrequencies, channelNamesLength)
        #If the signals are complex we're in the frequency domain.
        #Delaying in the frequency domain is the same as multiplying by exp(-j*2*pi*f*t)
        #The return value will be of size (numFrequencies x channelNamesLength x NumPoints) (Note we only consider 1 point here)
        delayedSignal = zeros(ComplexF64, size(frequencies, 1), size(delays, 2), 1)
        #TODO: Pre-allocate delayedSignal to avoid expensive call to add_dim
        
        delayedSignal =  signal .* exp.(-1im .* 2 .* pi .* (delays .* frequencies))




        if length(size(delayedSignal)) <= 2
            return Utilities.add_dim(delayedSignal)
        else
            return delayedSignal
        end
    end
end