module Utilities
    function add_dim(x)
        return reshape(x, (size(x)..., 1))
    end
end