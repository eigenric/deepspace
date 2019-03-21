#encoding: utf-8

module Deepspace

class ShieldBooster
    attr_reader :name, :boost, :uses

    def initialize(name, boost, uses)
        @name = name
        @boost = boost
        @uses = uses
    end

    def self.newCopy(copy)
        new(copy.name, copy.boost, copy.uses)
    end

    def useIt()
        if @uses > 0
            @uses -= 1
            @boost
        else
            1.0
        end
    end
end

end