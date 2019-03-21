# encoding:utf-8

module Deepspace

class Dice
    attr_reader :NHANGARSPROB, :NSHIELDSPROB, :NWEAPONSPROB, :FIRSTSHOTPROB, :generator

    def initialize()
      @NHANGARSPROB = 0.25 
      @NSHIELDSPROB = 0.25
      @NWEAPONSPROB = 0.33
      @FIRSTSHOTPROB = 0.5
      @generator = Random.new 
    end

    def initWithNHangars()
        @generator.rand <= @NHANGARSPROB ? 0: 1
    end

    def initWithNWeapons()
        n = @generator.rand
        n <= @NHANGARSPROB ? 1: (n <= 2*@NHANGARSPROB ? 2: 3)
    end

    def initWithNShields()
        @generator.rand <= @NSHIELDSPROB ? 0: 1
    end

    def whoStarts(nPlayers)
        @generator.rand(0..nPlayers-1)
    end

    def firstShot()
        [GameCharacter::SPACESTATION, GameCharacter::ENEMYSTARSHIP].sample
    end

    def spaceStationMoves?(speed)
        @generator.rand <= speed
    end

    def to_s()
        out="Dice \n"
        out+= "\tNHANGARSPROB: #{@NHANGARSPROB}"
        out+= "\tNSHIELDSPROB: #{@NHANGARSPROB}"
        out+= "\tNWEAPONSPROB: #{@NHANGARSPROB}"
        out+= "\tFIRSTSHOTPROB: #{@NHANGARSPROB}"
        return out
    end
end

end