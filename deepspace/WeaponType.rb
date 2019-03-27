#encoding: utf-8

module Deepspace

module WeaponType
    class Type
        attr_accessor :power

        def initialize(power)
            @power = power
        end

        def to_s
            case @power
            when 2.0
                "LASER"
            when 3.0
                "MISSILE"
            when 4.0
                "PLASMA"
            end
        end
    end

    LASER = Type.new(2.0)
    MISSILE = Type.new(3.0)
    PLASMA = Type.new(4.0)
end

end