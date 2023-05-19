require_relative 'lib/GameUniverseToUI'
require_relative 'lib/GameStateController'
require_relative 'CombatResult'
require_relative 'CardDealer'
require_relative 'SpaceStation'
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

    def init(names)
        state = @gameState.state
        if state == GameState::CANNOTPLAY
            dealer = CardDealer.instance
            names.each do |name|
                supplies = dealer.nextSuppliesPackage
                station = SpaceStation.new name, supplies
                @spaceStations << station

                nh = @dice.initWithNHangars
                nw = @dice.initWithNWeapons
                ns = @dice.initWithNShields
                
                lo = Loot.new 0, nw, ns, nh, 0
                station.loot = lo
            end

            @currentStationIndex = @dice.whoStarts names.size
            @currentStation = @spaceStations[@currentStationIndex]
            @currentEnemy = dealer.nextEnemy
            @gameState.next @turns, @spaceStations.size
        end
    end

    def nextTurn
        state = @gameState.state

        if state == GameState::AFTERCOMBAT
            stationState = @currentStation.validState?
            if stationState
                @currentStationIndex = (@currentStationIndex+1)% @spaceStations.size
                @turns += 1
                @currentStation = @spaceStations[@currentStationIndex]
                @currentStation.cleanUpMountedItems
                dealer = CardDealer.instance
                @currentEnemy = dealer.nextEnemy
                @gameState.next @turns, @spaceStations.size
                return true
            end
        end
        false
    end

    def combat
        state = @gameState.state
        if state == GameState::BEFORECOMBAT || state == GameState::INIT
            return combatGo @currentStation, @currentEnemy    
        end
        CombatResult::NOCOMBAT
    end


    def combatGo(station, enemy)
        ch = @dice.firstShot
        if ch == GameCharacter::ENEMYSTARSHIP
            fire = enemy.fire
            result = station.receiveShot fire

            if result == ShotResult::RESIST
                fire = station.fire
                result = enemy.receiveShot fire
                enemyWins = result == ShotResult::RESIST
            else
                enemyWins = true
            end
        else
            fire = station.fire
            result = enemy.receiveShot fire
            enemyWins = result == ShotResult::RESIST
        end

        if enemyWins
            s = station.speed
            moves = @dice.spaceStationMoves? s
            if !moves
                damage = enemy.damage
                station.pendingDamage = damage
                combatResult = CombatResult::ENEMYWINS
            else
                station.move
                combatResult = CombatResult::STATIONESCAPES
            end
        else
            aLoot = enemy.loot
            station.loot = aLoot
            combatResult = CombatResult::STATIONWINS
        end
        @gameState.next @turns, @spaceStations.size
        combatResult
    end

    def init_or_aftercombat()
        @gameState.state == GameState::INIT || @gameState.state == GameState::AFTERCOMBAT
    end

    def discardHangar()
        @currentStation.discardHangar() if init_or_aftercombat
    end

    def discardShieldBooster(i)
        @currentStation.discardShieldBooster(i) if init_or_aftercombat
    end

    def discardShieldBoosterInHangar(i)
        @currentStation.discardShieldBoosterInHangar(i) if init_or_aftercombat
    end

    def discardWeapon(i)
        @currentStation.discardWeapon(i) if init_or_aftercombat
    end

    def discardWeaponInHangar(i)
        @currentStation.discardWeaponInHangar(i) if init_or_aftercombat
    end

    def mountShieldBooster(i)
        @currentStation.mountShieldBooster(i) if init_or_aftercombat
    end

    def mountWeapon(i)
        @currentStation.mountWeapon(i) if init_or_aftercombat
    end

    def haveAWinner()
        @currentStation.nMedals >= @@WIN
    end

    def state
        @gameState.state
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