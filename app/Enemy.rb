# Enemy.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# This class attempts to handle every enemy ship; the exact behaviour is defined by the
# creation parameters

class Enemy < Ship
    
    # Create the enemy in the position and form ordained
    def initialize properties

        # Create the Sprite on which we'll draw the ship
        @sprite = AhnSprite.new "enemy#{object_id}", 128, 128

        # The form of enemy is based on the properties
        case properties[:type]
        when :enemy_saucer
            @sprite.sprites << { x: 18, y: 18, angle: 0, w: 91, h: 91, path: "sprites/ufo_green.png" }
            @speed = 2
            @spinning = true
        end

        # Some things we can just take directly
        @path = properties[:path]

        # Our spawn point is the first point on the path
        @x = @path[0][0]
        @y = @path[0][1]
        @path_step = 1

    end


    # Serialization
    def serialize
    { 
        x: @x, y: @y, sprite: @sprite, path: @path, path_step: @path_step, spinning: @spinning
    }
    end
    def inspect
        serialize.to_s
    end
    def to_s
        serialize.to_s
    end


    # Movement; we just move toward the next destination on the path, bound by our speed
    def move 

        # If we've reached the end of our path, not much to do
        if @path_step >= @path.length
            return
        end

        # So, just set the destination to the next step on the path and let the base
        # ship movement handle it
        @dest_x = @path[@path_step][0]
        @dest_y = @path[@path_step][1]
        super

        # Now just check to see if we've reached the target - if so, move on to the next
        # step on the path
        if ( @x == @path[@path_step][0] ) && ( @y == @path[@path_step][1] )
            @path_step += 1
        end

    end


    # Fire, spawns all the bullets required for the current weapon
    def fire 

        # Could end up spawning a number of bullets, depending on the weapon
        bullets = []

        # For now, we'll just spawn a small green laser bolt!
        bullets << Laser.new( :laser_small_green, @x - 64, @y + 64, false )

        # And just hand back that collection of bullets
        bullets

    end
    

    # We know how to draw ourselves
    def render args

        # Update the sprite location
        @sprite.x = @x
        @sprite.y = @y

        # Consider if the ship spins
        if @spinning
            @sprite.angle = ( @sprite.angle + 1 ) % 360
        end

        # We can simply render the sprite then
        args.outputs.primitives << @sprite
        @sprite.render_bounds args.outputs

    end

end

# End of Enemy.rb