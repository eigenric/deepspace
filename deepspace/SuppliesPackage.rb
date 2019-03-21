#encoding: utf-8

module Deepspace

class SuppliesPackage
    attr_reader :ammoPower, :fuelUnits, :shieldPower

    def initialize(ammoPower, fuelUnits, shieldPower)
        @ammoPower = ammoPower
        @fuelUnits = fuelUnits
        @shieldPower = shieldPower
    end

    def self.newCopy(copy)
        new(copy.ammoPower, copy.fuelUnits, copy.shieldPower)
    end

    def to_s()
        out="SuppliesPackage: "
        out+="\t ammoPower: #{@ammoPower}"
        out+="\t fuelUnits: #{@fuelUnits}"
        out+="\t shieldPower #{@shieldPower}"
        return out
    end
end

end