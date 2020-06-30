# Ship.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# The Ship class forms the basis for all flighted things in the game - players and enemies.
# It means that the logic for movement and suchlike can all be handled in one place,
# so that enemies and player ships all obey the basic same rules.

class Ship

    # Constructor; sets the internals to some sensible defaults
    def initialize x=nil, y=nil,speed=nil, turnspeed=nil
        
        # So, all ships have a location, speed, destination, rotation
        @x = x
        @y = y
        @speed = speed
        @turnspeed = turnspeed
        @dest_x = nil
        @dest_y = nil
        @rotation = 0

    end

    # Move, turn and fly toward the destination, if we have one
    def move

        # If we don't have a destination, we can't exactly move there!
        if @dest_x.nil? || @dest_y.nil?
            return
        end
        
    end

end