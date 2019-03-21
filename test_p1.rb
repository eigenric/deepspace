# encoding: utf-8

require 'pp'
require_relative 'deepspace/SuppliesPackage.rb'
require_relative 'deepspace/ShieldBooster.rb'
require_relative 'deepspace/Weapon.rb'
require_relative 'deepspace/WeaponType.rb'
require_relative 'deepspace/CombatResult.rb'
require_relative 'deepspace/Dice.rb'
require_relative 'deepspace/Loot.rb'
require_relative 'deepspace/GameCharacter.rb'
# Shotresult?

module Pruebas

class TestP1

    @@dado = Deepspace::Dice.new
    @@posibles_funcion =  {
        initWithNHangars: [[0,1], Proc.new { @@dado.initWithNHangars }],
        initWithNWeapons: [[1,2,3], Proc.new { @@dado.initWithNWeapons }],
        initWithNShields: [[0,1,2], Proc.new { @@dado.whoStarts(3) }],
        firstShot: [
                    [Deepspace::GameCharacter::SPACESTATION,
                     Deepspace::GameCharacter::ENEMYSTARSHIP],
                    Proc.new { @@dado.firstShot }
                   ],
        spaceStationMoves: [[true,false], Proc.new { @@dado.spaceStationMoves?(0.75) }]
    }

    # Devuelve la distribución de la función entre sus posibles 
    # en un total de n veces
    def self.throw_dice(n, posibles, funcion)
        # Setear todos los posibles a 0
        conteo = posibles.reduce({}) do |total, current|
            total.update(current => 0)
        end

        n.times do
            conteo[funcion.call] += 1
        end
        conteo
    end

    # n: número de veces a lanzar el dado
    # posibles_funcion: tabla hash con los nombres de las funciones como nombres
    # y con un array compuesto por los valores posibles (array) y los objetos Proc
    # para llamar a las funciones

    # Devuelve un hash cuyas claves son los nombres de las funciones y cuyos
    # valores son los arrays de frecuencia
    def self.throw_dices(n=100, posibles_funcion)

        posibles_funcion.keys.reduce({}) do |total, function_name|
            posibles = posibles_funcion[function_name].first
            function = posibles_funcion[function_name].last
            total.update(function_name => self.throw_dice(n, posibles, function))
        end
    end

    def main()
        package = Deepspace::SuppliesPackage.new(3.1,2.4,5.1)
        shield = Deepspace::ShieldBooster.new("Shield", 3.4, 2)
        laser = Deepspace::Weapon.new("Laser", Deepspace::WeaponType::LASER, 3)
        missil = Deepspace::Weapon.new("Missile", Deepspace::WeaponType::MISSILE, 2)
        weapon = Deepspace::Weapon.new("Plasma", Deepspace::WeaponType::PLASMA, 4)
        loot = Deepspace::Loot.new(1,2,3,4,5)

        self.class.throw_dices(100, @@posibles_funcion).each do |nombre, dist|
            puts "#{nombre}: "
            dist.each do |key, value|
                puts "\t#{key}: #{value}% \n"
            end
        end

    end
end

program = TestP1.new
program.main

end