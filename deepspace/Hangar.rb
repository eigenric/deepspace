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
        (@weapons.length + @shieldBoosters) != @maxElements
    end

    def addWeapon?(w)
        if spaceAvailable?
            @weapons << w
            true
        else
            false
        end
    end

    def addShieldBooster?(sb)
        if spaceAvailable?
            @shieldBoosters << w
            true
        else
            false
        end
    end

    def removeWeapon(nw)
        if nw <= @maxElements -1
            @weapons.delete_at nw
        else # Quizas esto no sea necesario
            nil 
        end
    end

    def removeShieldBooster(ns)
        if ns <= @maxElements -1
            @weapons.delete_at ns
        else
            nil
        end
    end

    def getUIVersion
        HangarToUI.new self
    end

    def to_s
        getUIVersion().to_s
    end

    private :spaceAvailable?

end # class

end # module