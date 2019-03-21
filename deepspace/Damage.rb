module Deepspace

class Damage

    attr_reader :nShields, :nWeapons, :weapons, :damage

    def self.newNumericWeapons(w, s)
        @nWeapons = n
        @nShields = s
    end

    def self.newSpecificWeapons(wl, s)

    end

    def self.newCopy(d)
        new(d.nWeapons, d.nShields)
    end

    def discardWeapon(w)
        
    end

    def discardShieldBooster
    end

    def hasNoEffect?
    end

    def arrayContainsType(weapons, wt)
    end

    def adjust(weapons, s)
    end

    def getUIVersion()
        return DamageToUI.new self
    end


end # Class

end # Module 