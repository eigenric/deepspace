require_relative 'lib/GameUniverseToUI'
require_relative 'lib/GameStateController'
require_relative 'Dice'

module Deepspace

class GameUniverse
    attr_reader :gameState
    @@WIN = 10
    
    def initialize()
        @gameState = GameStateController.new
        @turns = 0
        @dice = Dice.new
        @currentStationIndex = 0 #?
        @spaceStations = []
        @currentStation = nil
        @currentEnemy = nil
    end

    def init_or_aftercombat()
        @gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT
    end

    def discardHangar()
        @currentStation.discardHangar() unless init_or_aftercombat
    end

    def discardShieldBooster(i)
        @currentStation.discardShieldBooster(i) unless init_or_aftercombat
    end

    def discardShieldBoosterInHangar(i)
        @currentStation.discardShieldBoosterInHangar(i) unless init_or_aftercombat
    end

    def discardWeapon(i)
        @currentStation.discardWeapon(i) unless init_or_aftercombat
    end

    def discardWeaponInHangar(i)
        @currentStation.discardWeaponInHangar(i) unless init_or_aftercombat
    end

    def mountShieldBooster(i)
        @currentStation.mountShieldBooster(i) unless init_or_aftercombat
    end

    def mountWeapon(i)
        @currentStation.mountWeapon(i) unless init_or_aftercombat
    end

    def haveAWinner()
        @currentStation.nMedals == 10
    end

    def getUIversion()
        GameUniverseToUI.new @currentStation, @currentEnemy
    end

    def to_s()
        getUIversion().to_s
    end

    private :init_or_aftercombat
end # class

end # module

if $0 == __FILE__
    require_relative 'Loot'
    require_relative 'WeaponType'
    require_relative 'Damage'
    require_relative 'SpaceStation'
    require_relative 'SuppliesPackage'
    require_relative 'EnemyStarShip'
    
    sp = Deepspace::SuppliesPackage.new 3.4, 5.6, 7.8
    l = Deepspace::Loot.new 1, 2, 3, 4, 5
    weapons = [Deepspace::WeaponType::LASER, Deepspace::WeaponType::MISSILE, Deepspace::WeaponType::PLASMA]
    d = Deepspace::Damage.newSpecificWeapons weapons, 6
    esh = Deepspace::EnemyStarShip.new "Nave enemiga", 1.2, 3.4, l, d
    ss = Deepspace::SpaceStation.new "Nave del misterio", sp

    gu = Deepspace::GameUniverse.new

    puts "Ni init ni aftercombat" unless gu.send :init_or_aftercombat 

end