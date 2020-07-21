# Laser.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# This class defines lasers, both player and enemy ones. These are the simplest kind
# of bullet, that just travel in a straight horizontal line at a fixed speed.

class Laser < BulletInterface

    # Create ourselves
    def initialize type, x, y, ltr = false

        # The type of laser really only affects the graphics and the damage
        case type
        when :laser_small_green
            @spritea_src = "sprites/laser_green_1.png"
            @spriteb_src = "sprites/laser_green_2.png"
            @size = 37
            @widtha = 13
            @heighta = 37
            @widthb = 9
            @heightb = 37
            @damage = 1
            @speed = 10 * ( ltr == true ? 1 : -1 )
        when :laser_small_red
            @spritea_src = "sprites/laser_red_1.png"
            @spriteb_src = "sprites/laser_red_2.png"
            @size = 37
            @widtha = 13
            @heighta = 37
            @widthb = 9
            @heightb = 37
            @damage = 1
            @speed = 10 * ( ltr == true ? 1 : -1 )
        end

        # Create the right kind of Sprites to draw ourselves
        @spritea = AhnSprite.new "lasera#{object_id}", @size, @size
        @spritea.sprites << { x: (@size-@widtha).div(2), y: (@size-@heighta).div(2), angle: 270, w: @widtha, h: @heighta, path: @spritea_src }
        @spriteb = AhnSprite.new "laserb#{object_id}", @size, @size
        @spriteb.sprites << { x: (@size-@widthb).div(2), y: (@size-@heightb).div(2), angle: 270, w: @widthb, h: @heightb, path: @spriteb_src }
    
        # We're created at a specific location
        @x = x
        @y = y

    end


    # Serialization
    def serialize
    { 
        x: @x, y: @y, width: @width, height: @height, spritea: @spritea, spriteb: @spriteb, speed: @speed, damage: @damage,
    }
    end
    def inspect
        serialize.to_s
    end
    def to_s
        serialize.to_s
    end


    # Pass on collision detection
    def collides? target
        @spritea.collides?( target.sprite ) || @spriteb.collides?( target.sprite )
    end


    # Update our location, based on speed. Nice and simple horizontal movement
    def update args

        @x += @speed

    end


    # Determine if we have passed beyond the boundaries of the screen
    def outofbounds? grid

        if @x + @size < grid.left ||
           @x - @size > grid.right ||
           @y + @size < grid.bottom ||
           @y - @size  > grid.top
           return true
        end

        false

    end

    
    # We know how to draw ourselves
    def render args

        # Update the sprite locations
        @spritea.x = @x
        @spritea.y = @y
        @spriteb.x = @x
        @spriteb.y = @y

        # Lasers alternate between two frames, just to look a bit dynamic
        if args.state.tick_count.even?
            args.outputs.primitives << @spritea
            @spritea.render_bounds args.outputs
        else
            args.outputs.primitives << @spriteb
            @spriteb.render_bounds args.outputs
        end
        
    end


end

# End of Laser.rb