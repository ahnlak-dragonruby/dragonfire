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
        @spinning = false

    end

    # Move, turn and fly toward the destination, if we have one
    def move

        # If we don't have a destination, we can't exactly move there!
        if @dest_x.nil? || @dest_y.nil?
            return
        end

        # If it's on a horizontal then it's easy
        if @dest_y == @y
            move_x @speed * ( @dest_x > @x ? 1 : -1 )
            return
        end

        # The same if it's on a vertical
        if @dest_x == @x
            move_y @speed * ( @dest_y > @y ? 1 : -1 )
            return
        end

        # Sadly, this means we have to do trigonometry. Urgh.
        dx = @x.to_f - @dest_x
        dy = @y.to_f - @dest_y
        angle = Math::PI + ( Math.atan2( dx, dy ) )

        # So, work out the x and y components of this move
        move_x Math.sin( angle ) * @speed
        move_y Math.cos( angle ) * @speed
        
    end

    # Move toward a target, but don't go past it
    def move_x amount

        # Do the full movement.
        @x += amount

        # Check that we didn't go past the destination
        if amount.positive?
            if @x > @dest_x
                @x = @dest_x
            end
        else
            if @x < @dest_x
                @x = @dest_x
            end
        end

    end

    def move_y amount

        # Do the full movement.
        @y += amount

        # Check that we didn't go past the destination
        if amount.positive?
            if @y > @dest_y
                @y = @dest_y
            end
        else
            if @y < @dest_y
                @y = @dest_y
            end
        end

    end

end

# End of Ship.rb