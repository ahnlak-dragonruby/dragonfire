# interfaces.rb - part of DragonFire
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This software is distributed under the MIT License - see LICENSE.txt for more information.
#
# This file defines a few interfaces that are used to make sure that the
# right classes provide the right functions!

class WorldInterface

    def update args
        raise "All worlds must implement update!"
    end

    def render args
        raise "All worlds must implement render!"
    end

end

# End of interfaces.rb
