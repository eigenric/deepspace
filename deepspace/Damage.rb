require_relative 'lib/DamageToUI'

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
        unless d.weapons.nil?
            newSpecificWeapons(d.weapons, d.nShields)
        else
            newNumericWeapons(d.nWeapons, d.nShields)
        end
    end

    def discardWeapon(w)
        unless @weapons.nil? # Lista de weapon
            @weapons.delete w.type
        else
            @nWeapons -= if @nWeapons >= 1 then 1 else 0 end
        end
    end

    def discardShieldBooster
       @nShields -= if @nShields >= 1 then 1 else 0 end
    end

    def hasNoEffect?
        specific_zero = (@nWeapons == 0 && @weapons == nil)
        numeric_zero = (@nWeapons == -1 && @weapons.empty?)
        @nShields && (specific_zero || numeric_zero)
    end

    def arrayContainsType(weapons, wt)
        unless (f=weapons.index { |w| w.type == wt }).nil?
            f
        else
            -1
        end
    end

    def adjust(weapons, s)
        nSh = if @nShields < s.length then @nShields else s.length end

        if @nWeapons == -1 # Hay lista especifica
            wCopy = @weapons.clone
            adjustedWeapons = weapons.map do |w|
                wCopy.delete_at(wCopy.index(w.type) || wCopy.length)
            end
            adjustedWeapons.compact!
            self.class.newSpecificWeapons(adjustedWeapons, nSh)
        else
            nWeap = if @nWeapons < weapons.length then @nWeapons else weapons.length end
            self.class.newNumericWeapons(nWeap, nSh)
        end
    end

    def getUIversion()
        DamageToUI.new self
    end

    def to_s()
        getUIversion().to_s
    end

    private_class_method :new


end # Class

end # Module 

if $0 == __FILE__
    require_relative 'Weapon'
    require_relative 'ShieldBooster'
    require_relative 'WeaponType'
    
    damage1 = Deepspace::Damage.newNumericWeapons 5, 8 
    puts damage1
    damage1Copy = Deepspace::Damage.newCopy damage1
    puts "Copia damage tipo 1: #{ damage1Copy }"
    puts "Ajustado: "

    types = [Deepspace::WeaponType::LASER, Deepspace::WeaponType::MISSILE, Deepspace::WeaponType::PLASMA]
    damage2= Deepspace::Damage.newSpecificWeapons types, 5
    puts damage2
    damage2Copy = Deepspace::Damage.newCopy damage2
    puts "Copia damage tipo 2: #{ damage2Copy }"

    w = Deepspace::Weapon.new "Armilla", Deepspace::WeaponType::LASER, 8

    puts "Eliminando arma <#{ w }>"
    damage2.discardWeapon(w)
    puts damage2

    puts "Eliminando potenciador de escudo: "
    damage2.discardShieldBooster
    puts damage2

    w2 = Deepspace::Weapon.new "Armilla 2", Deepspace::WeaponType::MISSILE, 6

    puts "Lista de weapons: [#{w}, #{w2}]"

    i = damage2.arrayContainsType [w, w2], Deepspace::WeaponType::MISSILE

    if i.between?(0, 2)  # Encontrado
        puts "La primera arma de tipo #{Deepspace::WeaponType::MISSILE} es #{[w,w2][i]}"
    elsif i == -1 # No encontrado
        puts "El tipo #{Deepspace::WeaponType::MISSILE} no ha sido encontrado"
    end

    j = damage2.arrayContainsType([w, w2], Deepspace::WeaponType::PLASMA)

    if j.between?(0, 2)  # Encontrado
        puts "La primera arma de tipo #{Deepspace::WeaponType::PLASMA} es #{[w,w2][j]}"
    elsif j == -1 # No encontrado 
        puts "El tipo #{Deepspace::WeaponType::PLASMA} no ha sido encontrado"
    end

    laser = Deepspace::WeaponType::LASER
    misil = Deepspace::WeaponType::MISSILE
    plasma = Deepspace::WeaponType::PLASMA

    wlaser = Deepspace::Weapon.new "Laser", laser, 4
    wmisil = Deepspace::Weapon.new "Misil", misil, 4
    wplasma = Deepspace::Weapon.new "Misil", plasma, 4

    sb1 = Deepspace::ShieldBooster.new "Por escudo 1", 3.4, 6
    sb2 = Deepspace::ShieldBooster.new "Por escudo 2", 4.4, 3

    dmg = Deepspace::Damage.newSpecificWeapons [laser, misil, misil, misil] , 6

    puts "Sin ajustar: #{dmg}"
    weapons_to_adjust = [wplasma, wmisil, wmisil, wlaser, wplasma]
    puts "Ajustando con #{[weapons_to_adjust.join(", ")]}"
    adjusted = dmg.adjust(weapons_to_adjust, [sb1, sb2, sb1, sb2, sb1, sb2,sb2,sb1])
    puts "Ajustado: #{adjusted}"
    adjustedn = damage1.adjust(weapons_to_adjust, [sb1, sb2, sb2, sb2, sb1, sb2,sb2, sb1, sb2])
    puts "Ajustado numeric: #{adjustedn}"
    

end