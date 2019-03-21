#encoding: utf-8

module Deepspace

class Loot
    attr_accessor :nSupplies, :nWeapons, :nShields, :nHangars, :nMedals

    def initialize(nSupplies, nWeapons, nShields, nHangars, nMedals)
        @nSupplies = nSupplies
        @nWeapons = nWeapons
        @nShields = nShields
        @nHangars = nHangars
        @nMedals = nMedals
    end

    def getUIVersion
        return FooToUI.new self
    end

    def to_s
        out="Loot: "
        out="\t nSupplies: #{@nSupplies}"
        out="\t nWeapons: #{@nWeapons}"
        out="\t nShields: #{@nShields}"
        out="\t nHangars: #{@nHangars}"
        out="\t nMedals: #{@nMedals}"
        return out
    end
end

end