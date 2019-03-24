module Deepspace

require_relative './ShotResult.rb'

class EnemyStarShip
    attr_reader :ammoPower, :damage, :loot, :name, :shieldPower

    def initialize(ammoPower, name, shieldPower)
        @ammoPower = ammoPower
        @name = name
        @shieldPower = shieldPower
    end

    def self.newCopy(e)
        new(e.ammoPower, e.name, e.shieldPower)
    end

    def fire()
        @ammoPower
    end

    def protection()
        @shieldPower
    end

    def receiveShot(shot)
        if @shieldPower < ammoPower
            ShotResult::DONOTRESIST
        else ShotResult::RESIST
        end
    end
end # class
end # module