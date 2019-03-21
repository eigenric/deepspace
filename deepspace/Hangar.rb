module Deepspace

class Hangar
    attr_reader :maxElements, :shieldBoosters, :weapons

    def initialize(capacity)
        @maxElements = capacity
    end

    def self.newCopy(copy)
        new(copy.maxElements)
    end

    def spaceAvailable?
    end

    def addWeapon?(w)
    end

    def addShieldBooster?(sb)
    end

    def removeWeapon(w)
    end

    def removeShieldBooster(s)
    end

    def getUIVersion
        return HangarToUI.new self
    end

    private :spaceAvailable?

end # class

end # module