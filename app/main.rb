# main.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# This is the initial file, which contains the 'tick' handler for DR.
# It is also the *only* place that should be require'ing other files.

# We use the AhnSprite library for flexibility
$gtk.require 'app/AhnSprite.rb'

# We need some interfaces defined before anything else
$gtk.require 'app/interfaces.rb'

# And lastly, our classes
$gtk.require 'app/Ship.rb'
$gtk.require 'app/Laser.rb'
$gtk.require 'app/Player.rb'
$gtk.require 'app/Enemy.rb'
$gtk.require 'app/GameWorld.rb'


# The initializer that only gets called once at launch - when tick_count is zero.
def main_init args

    # We always need a game world object, which holds the current world.
    args.state.world_type = :game
    spawn_mode args

end


# Single point at which we create a new game world object, based on the current world type
def spawn_mode args

    # There are various world types, but they all must implement the World interface,
    # so they can all be treated largely the same
    case args.state.world_type
    when :game
        args.state.world = GameWorld.new args
    end

end


# The main tick handler; a lot happens here, but tucked away tidily in functions
# so you can hopefully see the logic flow a little better.
def tick args

    # For the first tick only, call the main init function
    if args.state.tick_count.zero?
        main_init args
    end

    # Each frame is basically the same then; update the world and then render it.
    mode_change = false
    if !args.state.world.update args
        spawn_mode args
    end

    # Thanks to the interface, we can just ask all worlds to render themselves
    args.state.world.render args

end

# End of main.rb
