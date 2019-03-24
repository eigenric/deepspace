module Deepspace

class SpaceStation
    attr_reader :ammoPower, :fuelUnits, :name, :nMedals, :shieldPower \
                ,:pendingDamage, :weapons, :shieldBoosters, :hangar
    
    attr_writer :loot 

    @@MAXFUEL=100
    @@SHIELDLOSSPERUNITSHOT=0.1

    def initialize(n, supplies)
        @name = n
        @ammoPower = supplies.ammoPower
        @fuelUnits = supplies.fuelUnits
        @shieldPower = supplies.shieldPower
        @nMedals = nil # ¿De dónde se obtiene?
        @pendingDamage = nil # 0..1
        @hangar = nil # 0..1
        @shieldBoosters = []
        @weapons = []
    end

    def assignFuelValue(f)
        if f <= @@MAXFUEL
            @fuelUnits = f
        end
    end

    def cleanPendingDamage()
        if @pendingDamage.hasNoEffect?
            @pendingDamage = nil
    end

    def receiveWeapon(w)
        unless @hangar.nil?
            @hangar.addWeapon(h)
        else
            false
        end
    end

    def receiveShieldBooster(s)
        unless @hangar.nil?
            @hangar.addShieldsBooster(s)
        else
            false
        end
    end

    def receiveHangar(h)
        @hangar = h if @hangar.nil?
    end

    def discardHangar()
        @hangar = nil
    end

    def receiveSupplies(s)
        @ammoPower += s.ammoPower
        @fuelUnits += s.fuelUnits
        @shieldPower += s.shieldPower
    end

    def pendingDamage=(d)
        @pendingDamage = d.adjust(@weapons, @shieldBoosters)
    end

    def mountWeapon(i)
        unless @hangar.nil? # Se dispone de hangar
            removedWeapon = @hangar.removeWeapon i
            @weapons << removeWeapon unless removeWeapon.nil?
        end
    end

    def mountShieldBooster(i)
        unless @hangar.nil?
            removedsb = @hangar.removeShieldBooster i
            @shieldBoosters << removedsb unless removedsb.nil?
        end
    end

    def discardWeaponInHangar(i)
        @hangar.removeWeapon(i) unless @hangar.nil?
    end

    def discardShieldBoosterInHangar(i)
        @hangar.removeShieldBooster(i) unless @hangar.nil?
    end

    def getSpeed()
        @fuelUnits / @@MAXFUEL
    end

    def move()
        diff = @fuelUnits-getSpeed()
        @fuelUnits = diff unless diff < 0
    end

    def validState()
        pendingDamage.nil? or pendingDamage.hasNoEffect?
    end

    def cleanUpMountedItems()
        @weapons.reject! { |w| w.uses.zero? }
        @shieldBoosters.reject! { |s| s.uses.zero? }
    end

    def getUIVersion()
        SpaceStationToUI.new self
    end

    def to_s
        getUIVersion().to_s
    end

end # class

end # module