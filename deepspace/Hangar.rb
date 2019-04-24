require_relative 'lib/HangarToUI'

module Deepspace

class Hangar
    attr_reader :maxElements, :shieldBoosters, :weapons

    def initialize(capacity)
        @maxElements = capacity
        @weapons = []
        @shieldBoosters = []
    end

    def self.newCopy(copy)
        new(copy.maxElements)
    end

    def spaceAvailable?
        (@weapons.length + @shieldBoosters.length) != @maxElements
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
            @shieldBoosters << sb
            true
        else
            false
        end
    end

    def removeWeapon(nw)
        if nw.between?(0, @maxElements-1)
            @weapons.delete_at nw
        else # Quizas esto no sea necesario
            nil 
        end
    end

    def removeShieldBooster(ns)
        if ns.between?(0, @maxElements-1)
            @shieldBoosters.delete_at ns
        else
            nil
        end
    end

    def getUIversion
        HangarToUI.new self
    end

    def to_s
        getUIversion().to_s
    end

    private :spaceAvailable?

end # class

end # module

if $0 == __FILE__
    require_relative 'Weapon'
    require_relative 'ShieldBooster'
    require_relative 'WeaponType'


    hangar=Deepspace::Hangar.new(10)

    types = [Deepspace::WeaponType::LASER, Deepspace::WeaponType::MISSILE, Deepspace::WeaponType::PLASMA]

    4.times do |i|
        w = Deepspace::Weapon.new "Arma #{i}", types[i%3], 4
        s = Deepspace::ShieldBooster.new "Escudo #{i}", 3.2, 5
        hangar.addWeapon? w
        hangar.addShieldBooster? s
    end

    puts "Espacio disponible (8/10)?: #{ hangar.send :spaceAvailable? } "

    w = Deepspace::Weapon.new "Arma 10", Deepspace::WeaponType::MISSILE, 4
    s = Deepspace::ShieldBooster.new "Escudo 10", 3.9, 5
    hangar.addWeapon? w
    hangar.addShieldBooster? s

    puts "Espacio disponible (10/10)?: #{ hangar.send :spaceAvailable? } "

    puts "Hangar: #{ hangar }"
    puts "Eliminando arma..."
    hangar.removeWeapon 3
    puts "Hangar: #{ hangar }"
    puts "Eliminando potenciador de escudo.."
    if (hangar.removeShieldBooster(5).nil?)
        puts "Posición incorrecta"
    end
    puts "Espacio disponible (9/10)?: #{ hangar.send :spaceAvailable? } "
   
end