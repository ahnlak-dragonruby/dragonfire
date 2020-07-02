# interfaces.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# This file defines a few interfaces that are used to make sure that the
# right classes provide the right functions!

# Every 'mode' of the game is represented by a World. Every World provides a basic
# update and render approach
class WorldInterface

    def update args
        raise "All worlds must implement update!"
    end

    def render args
        raise "All worlds must implement render!"
    end

end


# Bullets are a catch-all term for all weapons fire - laser, missiles, et al.
# However they appear, they're all basically the same...
class BulletInterface

    def update args
        raise "All bullets must implement update!"
    end

    def render args
        raise "All bullets must implement render!"
    end

    def outofbounds? grid
        raise "All bullers must check out of bounds!"
    end

end

# End of interfaces.rb
