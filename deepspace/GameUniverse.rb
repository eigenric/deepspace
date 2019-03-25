require_relative 'GameUniverseToUI'
require_relative 'GameStateController'
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
        GameUniverseToUI.new self
    end

    def to_s()
        getUIversion().to_s
    end

    private :init_or_aftercombat
end # class

end # module