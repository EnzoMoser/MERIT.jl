module Process
    include("Utilities.jl")

    function delay_signal(signal, delays, frequencies)
        #TODO: Impliment delay in the time domain 
        #Assuming signals are complex (i.e in the frequency domain)
        

        #Signals will be of size (numFrequencies, channelNamesLength)
        if !isreal(signal)
            #If the signals are complex we're in the frequency domain.
            #Delaying in the frequency domain is the same as multiplying by exp(-j*2*pi*f*t)
            #The return value will be of size (numFrequencies x channelNamesLength x NumPoints)
            delayedSignal =  signal .* exp.(-1im * 2 * pi * (delays .* frequencies))

            if length(size(delayedSignal)) <= 2
                return Utilities.add_dim(delayedSignal)
            else
                return delayedSignal
            end            
        end
    end
end