
# An interface to define strategies 
# Subclass this to define concrete strategies. 
class Strategy
    def do_it (robot)
        raise NotImplementedError.new("Unimplemented Strategy")
    end
end

