# encoding:utf-8
require_relative 'lib/WeaponToUI'

module Deepspace

class Weapon
    attr_accessor :name, :type, :uses

    def initialize(name, type, uses)
        @name = name
        @type = type
        @uses = uses
    end

    def self.newCopy(copy)
        new(copy.name, copy.type, copy.uses)
    end

    def power()
        @type.boost
    end

    def useIt()
        if @uses > 0
            @uses -= 1
        else
            1.0
        end
    end

    def getUIversion
        WeaponToUI.new self
    end

    def to_s
        getUIversion().to_s
    end
end

end