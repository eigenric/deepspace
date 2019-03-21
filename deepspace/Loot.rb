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
end

end