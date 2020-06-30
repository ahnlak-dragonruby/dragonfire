# GameWorld.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# This file implements the GameWorld class, which is the main handling class
# for when we're in game mode (as opposed to the title screen, end credits and
# suchlike)

class GameWorld < WorldInterface

    # Some constants, so if things change I only have to change one thing
    BACKDROP_WIDTH = 256
    BACKDROP_HEIGHT = 256


    # Initialiser; set up the static aspects of the world the player will travel in
    def initialize grid

        # Build the scrolling backdrop - for now, the backdrop is split in half because of Reasons.
        divide = grid.center_x.div( BACKDROP_WIDTH ) * BACKDROP_WIDTH
        @backdropl_spr = AhnSprite.new "backdrop", divide, grid.h
        0.step( grid.h, BACKDROP_HEIGHT ).each do |row|
            0.step( ( divide ) + BACKDROP_WIDTH, BACKDROP_WIDTH ).each do |col|
                @backdropl_spr.sprites << { x: col, y: row, w: BACKDROP_WIDTH, h: BACKDROP_HEIGHT, path: "sprites/backdrop.png" }
            end
        end
        @backdropl_spr.x = 0

        @backdropr_spr = AhnSprite.new "backdrop", grid.w - divide, grid.h
        0.step( grid.h, BACKDROP_HEIGHT ).each do |row|
            0.step( ( grid.w - divide ) + BACKDROP_WIDTH, BACKDROP_WIDTH ).each do |col|
                @backdropr_spr.sprites << { x: col, y: row, w: BACKDROP_WIDTH, h: BACKDROP_HEIGHT, path: "sprites/backdrop.png" }
            end
        end
        @backdropr_spr.x = divide

        # Set up the world; leave the player empty, update will spawn him/her
        @player = nil
        @lives = 3

    end


    # Serialization
    def serialize
    { 
        backdropl_spr: @backdropl_spr, backdropr_spr: @backdropr_spr, 
        player: @player, lives: @lives,
    }
    end
    def inspect
        serialize.to_s
    end
    def to_s
        serialize.to_s
    end
    

    # Update; the function called every frame to update the world view
    def update args

        # Keep the backdrop scrolling, always...
        @backdropl_spr.source_x += 2
        if @backdropl_spr.source_x > BACKDROP_WIDTH 
            @backdropl_spr.source_x = 0
        end
        @backdropr_spr.source_x = @backdropl_spr.source_x

        # Check to see if the player needs creating
        if @player.nil? && @lives.positive?
            @player = Player.new args
        end


        # User input; see if we're moving first off
        horizontal = 0
        vertical = 0
        if args.inputs.keyboard.key_held.up || args.inputs.keyboard.key_held.w || args.inputs.controller_one.key_held.up
            vertical = 1
        end
        if args.inputs.keyboard.key_held.down || args.inputs.keyboard.key_held.s || args.inputs.controller_one.key_held.down
            vertical = -1
        end
        if args.inputs.keyboard.key_held.right || args.inputs.keyboard.key_held.d || args.inputs.controller_one.key_held.right
            horizontal = 1
        end
        if args.inputs.keyboard.key_held.left || args.inputs.keyboard.key_held.a || args.inputs.controller_one.key_held.left
            horizontal = -1
        end

        @player.move horizontal, vertical

        # Everything is fine, stick with this world!
        true

    end


    # Render; the function called every frame to draw the world
    def render args

        # Draw the backdrop across the whole page first
        args.outputs.primitives << @backdropl_spr
        args.outputs.primitives << @backdropr_spr

        # Draw the player; the object knows best how to do that...
        @player.render args

    end

end

# End of GameWorld.rb