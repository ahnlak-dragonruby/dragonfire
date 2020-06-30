# Player.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# This class defines the player's ship. Other stuff like scores are handled by
# the gameworld, not the player

class Player < Ship
    
    # Create ourselves, with a base ship
    def initialize args

        # Create the Sprite on which we'll draw the ship
        @sprite = AhnSprite.new "player", 128, 128

        # And draw the base ship, which as a player should face *right*
        @sprite.sprites << { x: 13, y: 26, angle: 270, w: 112, h: 75, path: "sprites/player_ship_1.png" }

        # We will always spawn in the same place, mid-height and near the left edge
        @x = 64
        @y = args.grid.center_y - 64
        @speed = 5

        # Probably worth remembering our bounds now
        @bounds_left = 0
        @bounds_bottom = 0
        @bounds_right = args.grid.right - 128
        @bounds_top = args.grid.top - 128

        # When we spawn, we have a second of immunity, indicated by flashing
        @immune_until = args.tick_count + 60

    end


    # Serialization
    def serialize
    { 
        x: @x, y: @y, sprite: @sprite, immune_until: @immune_until,
    }
    end
    def inspect
        serialize.to_s
    end
    def to_s
        serialize.to_s
    end


    # Movement; player ship is relatively easy in that it only moves up/down/left/right
    # without any tedious rotation, at the maximum speed we allow
    def move horizontal, vertical

        # So, if horizontal is positive (and we can), we move up
        if horizontal.positive? && @x < @bounds_right
            @x += @speed
        end

        # And the other  directions too
        if horizontal.negative? && @x > @bounds_left
            @x -= @speed
        end
        if vertical.positive? && @y < @bounds_top
            @y += @speed
        end
        if vertical.negative? && @y > @bounds_bottom
            @y -= @speed
        end

    end
    

    # We know how to draw ourselves
    def render args

        # Update the sprite location
        @sprite.x = @x
        @sprite.y = @y

        # Set the alpha, if we're immune
        if @immune_until > args.tick_count
            flicker = (@immune_until - args.tick_count) % 10
            if ( flicker < 5 )
                @sprite.a = 128 - ( flicker * 10 )
            else
                @sprite.a = 128 + ( flicker * 10 ) - 100
            end
        else
            @sprite.a = 255
        end

        # We can simply render the sprite then
        args.outputs.primitives << @sprite
        puts @sprite

    end

end