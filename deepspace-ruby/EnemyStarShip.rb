module Deepspace

require_relative 'ShotResult'
require_relative 'lib/EnemyToUI'

class EnemyStarShip
    attr_reader :name, :ammoPower, :shieldPower, :loot, :damage

    def initialize(name, ammoPower, shieldPower, loot, damage)
        @ammoPower = ammoPower
        @name = name
        @shieldPower = shieldPower
        @loot = loot
        @damage = damage
    end

    def self.newCopy(e)
        new(e.name, e.ammoPower, e.shieldPower, e.loot, e.damage)
    end

    def fire()
        @ammoPower
    end

    def protection()
        @shieldPower
    end

    def receiveShot(shot)
        if @shieldPower < shot
            ShotResult::DONOTRESIST
        else
            ShotResult::RESIST
        end
    end

    def getUIversion
        EnemyToUI.new self
    end

    def to_s
        getUIversion().to_s
    end
end # class
end # module

if $0 == __FILE__
    require_relative 'Loot'
    require_relative 'Damage'

    loot = Deepspace::Loot.new 1,2,3,4,5
    damage = Deepspace::Damage.newNumericWeapons 3, 5
    enemystarship = Deepspace::EnemyStarShip.new "Nave enemiga", 3.1, 4.3, loot, damage
    puts enemystarship
    enemyssCopy = Deepspace::EnemyStarShip.newCopy(enemystarship)
    puts "Copia de la anterior: "
    puts enemyssCopy

    puts "Proteccion: #{ enemystarship.protection }"
    puts "Fuego: #{ enemystarship.fire }"
    puts "Resultado disparo: 3.5 #{ enemystarship.receiveShot(3.5) }"
    puts "Resultado disparo: 5.5 #{ enemystarship.receiveShot(5.5) }"
end