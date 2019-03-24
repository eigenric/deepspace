module Deepspace

class Damage

    attr_reader :nShields, :nWeapons, :weapons, :damage

    def initialize(nWeapons, nShields, weapons)
        @nWeapons = nWeapons
        @nShields = nShields
        @weapons = weapons
    end

    def self.newNumericWeapons(w, s)
        new(w, s, nil)
    end

    def self.newSpecificWeapons(wl, s)
        new(-1, s, wl)
    end

    def self.newCopy(d)
        new(d.nWeapons, d.nShields)
    end

    def discardWeapon(w)
        if @weapons != nil # Lista de weapon
            @weapons.delete w.type
        else
            @nWeapons -= if @nWeapons >= 1 then 1 else 0
        end
    end

    def discardShieldBooster
       @nWeapons -= if @nWeapons >= 1 then 1 else 0
    end

    def hasNoEffect?
        specific_zero = (@nWeapons == 0 && @weapons == nil)
        numeric_zero = (@nWeapons == -1 && @weapons.empty?)
        @nShields && (specific_zero || numeric_zero)
    end

    def arrayContainsType(weapons, wt)
        if weapons.find {|w| w.type == wt }.nil?
            weapons.index wp
        else
            -1
        end
    end

    def adjust(weapons, s)
        adjustedWeapons = @weapons
        if @nWeapons == -1 # Hay lista especifica
            adjustedWeapons = weapons.map do |w|
                w.type if @weapons.include? w.type 
            end
            adjustedWeapons.compact!
        end
        self.new(adjustedWeapons, s.length)
    end

    def getUIVersion()
        DamageToUI.new self
    end

    def to_s()
        Damage
    end

    private_class_method :new


end # Class

end # Module 