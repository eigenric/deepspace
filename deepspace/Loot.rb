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

    def getUIversion
        FooToUI.new self
    end

    def to_s
        getUIversion().to_s
    end
end

end