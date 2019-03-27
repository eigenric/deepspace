require_relative 'lib/SpaceStationToUI'

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
        @nMedals = 0
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
            @weapons << removedWeapon unless removedWeapon.nil?
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
        @fuelUnits / @@MAXFUEL.to_f
    end

    def move()
        diff = @fuelUnits-@fuelUnits*getSpeed()
        @fuelUnits = diff unless diff < 0
    end

    def validState?
        pendingDamage.nil? || pendingDamage.hasNoEffect?
    end

    def cleanUpMountedItems()
        @weapons.reject! { |w| w.uses.zero? }
        @shieldBoosters.reject! { |s| s.uses.zero? }
    end

    def getUIversion()
        SpaceStationToUI.new self
    end

    def to_s
        getUIversion().to_s
    end

end # class

end # module

if $0 == __FILE__
    require_relative 'Hangar'
    require_relative 'Damage'
    require_relative 'SuppliesPackage'
    require_relative 'ShieldBooster'
    require_relative 'Weapon'
    require_relative 'WeaponType'

    sp = Deepspace::SuppliesPackage.new 3.4, 5.8, 1.3
    ss = Deepspace::SpaceStation.new "Estacion espacio", sp

    w1 = Deepspace::Weapon.new "Albolote 1", Deepspace::WeaponType::LASER, 8
    w2 = Deepspace::Weapon.new "Albolote 2", Deepspace::WeaponType::MISSILE, 8
    w3 = Deepspace::Weapon.new "Albolote 3", Deepspace::WeaponType::PLASMA, 8

    sb1 = Deepspace::ShieldBooster.new "Esc 1", 3.4, 8
    sb2 = Deepspace::ShieldBooster.new "Esc 2", 4.4, 8
    sb3 = Deepspace::ShieldBooster.new "Esc 3", 5.4, 8

    puts ss
    puts "Cambiando fuelValue a 7: "
    ss.assignFuelValue(7)
    puts ss

    puts "Velocidad: #{ ss.getSpeed }"

    puts "Moviendo nave: "
    ss.move
    puts "Fuel tras mover: #{ ss.fuelUnits }"

    h = Deepspace::Hangar.new 10
    h.addWeapon? w1
    h.addWeapon? w2
    h.addWeapon? w3

    h.addShieldBooster? sb1
    h.addShieldBooster? sb2
    h.addShieldBooster? sb3

    puts "Recibiendo hangar: "
    ss.receiveHangar h
    puts ss

    puts "Montando arma ultima y primer arma"
    ss.mountWeapon 2
    ss.mountWeapon 0
    puts ss

    puts "Montando p esc primero y penúltimo"
    ss.mountShieldBooster 1
    ss.mountShieldBooster 0 
    puts ss


    puts "Añadiendo DamageNumeric: "
    ss.pendingDamage = Deepspace::Damage.newNumericWeapons 1,3
    puts ss

    weapons = [w1.type, w2.type, w3.type]
    #sbs = [sb1, sb2, sb3]
    puts "Añadiendo DamageSpecific: "
    ss.pendingDamage = Deepspace::Damage.newSpecificWeapons weapons, 5
    puts ss

    sp2 = Deepspace::SuppliesPackage.new 1, 1, 1
    puts "Modificando SuppliesPackage: "
    ss.receiveSupplies sp2
    puts ss

    puts "Descartado primera arma y primer pot. escudo: "
    ss.discardWeaponInHangar(0)
    ss.discardShieldBoosterInHangar(0)
    puts ss

    puts "Evaluando estado: "
    if ss.validState?
        puts "Estado válido"
    else
        puts "Estado inválido. Sin daño pendiente o sin daño con efecto"
    end

    puts "Descartando todo el damage: "
    ss.pendingDamage.discardShieldBooster
    ss.pendingDamage.discardShieldBooster
    ss.pendingDamage.discardWeapon w1
    ss.pendingDamage.discardWeapon w3
    puts ss

    puts "Evaluando estado: "
    if ss.validState?
        puts "Estado válido. Daño pendiente nulo o sin efecto"
    else
        puts "Estado inválido. Sin daño pendiente o sin daño con efecto"
    end

    puts "Borrando daño pendiente..."
    ss.cleanPendingDamage
    puts "Ahora el daño pendiente es nulo" if ss.pendingDamage.nil?

    puts "Evaluando estado: "
    if ss.validState?
        puts "Estado válido. Daño pendiente nulo o sin efecto"
    else
        puts "Estado inválido. Sin daño pendiente o sin daño con efecto"
    end

    n = ss.weapons[0].uses
    puts "Usando la primera arma #{ n } veces"
    n.times do |i|
        ss.weapons[0].useIt
    end

    m = ss.shieldBoosters[0].uses
    puts "Usando el primer potenciador de escudo #{ m } veces"
    m.times do |i|
        ss.shieldBoosters[0].useIt
    end

    puts ss

    puts "Eliminando armas y potenciadores de escudo sin usos: "
    ss.cleanUpMountedItems
    puts ss

    puts "Intentando sustituir hangar por otro: "
    ssCopy = ss
    ss.receiveHangar Deepspace::Hangar.new 5
    puts "No ha hecho efecto" if ss == ssCopy

    puts "Eliminando hangar: "
    ss.discardHangar
    puts ss

    puts "Recibiendo arma: #{w1}"
    puts "Arma no recibida (no hay hangar)" unless ss.receiveWeapon w1
    puts "Recibiendo p escudo: #{sb1}"
    puts "P Escudo no recibido (no hay hangar)" unless ss.receiveShieldBooster sb1
    
    puts "Intentando montar arma y p. escudo: "
    ssCopy = ss
    ss.mountWeapon 0
    puts "No ha hecho efecto" if ssCopy == ss
    ssCopy2 = ss
    ss.mountShieldBooster 0 
    puts "No ha hecho efecto" if ssCopy2 == ss

    puts ss

end