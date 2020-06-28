# AhnSprite.rb
#
# Copyright (c) 2020 Pete Favelle <dragonruby@ahnlak.com>
# This file is licensed under the MIT License. See LICENSE for more details.
#
# This is an advanced sprite class, which renders everything through render_targets so that we can
# control things like z-order.
#
# These classes can be sent to args.outputs.(static_)sprites or args.outputs.(static_)primitives,
# to ensure that things get rendered in the right order. To that end, I would suggest:
#
# args.outputs.primitives for per-frame sprites,
# args.outputs.static_sprites for static sprites that are in the background, and
# args.outputs.static_primites for static sprites that are in the foreground.
#
# Within those groups, you can use the z parameter to order rendering each of those groups:
#
#     ArrayOfAhnSprites.sort { |a,b| a.z <=> b.z }.each { |sprite| args.outputs.primitives << sprite }



class AhnSprite


    # Pick up the attributes required to render as a sprite
    attr_sprite
    attr_accessor :z


    # Creation; we need some basic attributes for anything to make sense
    def initialize p_name, p_width, p_height

        # So at least we've got our dimensions and a name
        @path = p_name
        @source_x = 0
        @source_y = 0
        @source_w = p_width
        @source_h = p_height

        # Fill in some defaults for the rest
        @x = 0
        @y = 0
        @z = 0
        @w = @source_w
        @h = @source_h

    end


    # Serialization
    def serialize

        { 
            name: @path, x: @x, y: @y, z: @z, w: @w, h: @h, 
            source_x: @source_x, source_y: @source_y, 
            source_w: @source_w, source_h: @source_h, 
        }

    end
    def inspect
        serialize.to_s
    end
    def to_s
        serialize.to_s
    end


    # Expose the drawing primitives
    def solids
        $gtk.args.render_target( @path ).solids
    end
    def sprites
        $gtk.args.render_target( @path ).sprites
    end
    def labels
        $gtk.args.render_target( @path ).labels
    end
    def lines
        $gtk.args.render_target( @path ).lines
    end
    def borders
        $gtk.args.render_target( @path ).borders
    end


end