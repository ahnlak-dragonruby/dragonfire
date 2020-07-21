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


# This class is used to provide a wrapper to the render_target primitives, so that we can save boundary
# details on the way in. Trying to access render_target data seems to break things a bit.
class AhnPrimitive

    # We'll need the render_target name, and the primitive type
    def initialize p_name, p_type

        @path = p_name
        @type = p_type
        @boundaries = []

    end

    # Allow hashes to be dropped into us in exactly the way that render_target primitives are
    def << p_args

        # Save the boundaries, and add it to the right primitive
        case @type
        when :solid
            boundary = {
                x1: p_args[:x],              y1: p_args[:y],
                x2: p_args[:x] + p_args[:w], y2: p_args[:y],
                x3: p_args[:x] + p_args[:w], y3: p_args[:y] + p_args[:h],
                x4: p_args[:x],              y4: p_args[:y] + p_args[:h]
            }
            $gtk.args.render_target( @path ).solids << p_args
        when :sprite
            # Sprites are tricky, because the angle affects things
            temp_bounds = {
                x1: p_args[:x],              y1: p_args[:y],
                x2: p_args[:x] + p_args[:w], y2: p_args[:y],
                x3: p_args[:x] + p_args[:w], y3: p_args[:y] + p_args[:h],
                x4: p_args[:x],              y4: p_args[:y] + p_args[:h]
            }
            boundary = rotate( temp_bounds, p_args[:angle], p_args[:x]+p_args[:w]/2, p_args[:y]+p_args[:h]/2 )
            $gtk.args.render_target( @path ).sprites << p_args
        when :label
            boundary = {
                x1: p_args[:x],              y1: p_args[:y],
                x2: p_args[:x] + p_args[:w], y2: p_args[:y],
                x3: p_args[:x] + p_args[:w], y3: p_args[:y] + p_args[:h],
                x4: p_args[:x],              y4: p_args[:y] + p_args[:h]
            }
            $gtk.args.render_target( @path ).labels << p_args
        when :line
            boundary = {
                x1: p_args[:x],              y1: p_args[:y],
                x2: p_args[:x] + p_args[:w], y2: p_args[:y],
                x3: p_args[:x] + p_args[:w], y3: p_args[:y] + p_args[:h],
                x4: p_args[:x],              y4: p_args[:y] + p_args[:h]
            }
            $gtk.args.render_target( @path ).lines << p_args
        when :border
            boundary = {
                x1: p_args[:x],              y1: p_args[:y],
                x2: p_args[:x] + p_args[:w], y2: p_args[:y],
                x3: p_args[:x] + p_args[:w], y3: p_args[:y] + p_args[:h],
                x4: p_args[:x],              y4: p_args[:y] + p_args[:h]
            }
            $gtk.args.render_target( @path ).borders << p_args
        end

        # And add the boundary
        @boundaries << boundary

    end

    # Offset the boundary, as required
    def boundaries p_x, p_y

        # We build up a list of boxes to represent the boundaries. These may (will?) overlap
        boxes = []

        # Apply the offset
        @boundaries.each do | boundary |
            boxes << {
                x1: boundary[:x1] + p_x, y1: boundary[:y1] + p_y,
                x2: boundary[:x2] + p_x, y2: boundary[:y2] + p_y,
                x3: boundary[:x3] + p_x, y3: boundary[:y3] + p_y,
                x4: boundary[:x4] + p_x, y4: boundary[:y4] + p_y
            }
        end

        boxes

    end

    # Rotate a boundary, about a given anchor point
    def rotate p_args, p_angle, p_anchor_x, p_anchor_y

        # Check that we have an angle and it's non-zero, or nothing to do
        if p_angle.nil? || p_angle.zero?
            return p_args
        end

        # We'll need the angle in radians, obviously
        angle = p_angle.to_radians

        new_x1 = Math.cos(angle) * (p_args[:x1] - p_anchor_x) - Math.sin(angle) * (p_args[:y1] - p_anchor_y) + p_anchor_x;
        new_x2 = Math.cos(angle) * (p_args[:x2] - p_anchor_x) - Math.sin(angle) * (p_args[:y2] - p_anchor_y) + p_anchor_x;
        new_x3 = Math.cos(angle) * (p_args[:x3] - p_anchor_x) - Math.sin(angle) * (p_args[:y3] - p_anchor_y) + p_anchor_x;
        new_x4 = Math.cos(angle) * (p_args[:x4] - p_anchor_x) - Math.sin(angle) * (p_args[:y4] - p_anchor_y) + p_anchor_x;
        new_y1 = Math.sin(angle) * (p_args[:x1] - p_anchor_x) + Math.cos(angle) * (p_args[:y1] - p_anchor_y) + p_anchor_y;
        new_y2 = Math.sin(angle) * (p_args[:x2] - p_anchor_x) + Math.cos(angle) * (p_args[:y2] - p_anchor_y) + p_anchor_y;
        new_y3 = Math.sin(angle) * (p_args[:x3] - p_anchor_x) + Math.cos(angle) * (p_args[:y3] - p_anchor_y) + p_anchor_y;
        new_y4 = Math.sin(angle) * (p_args[:x4] - p_anchor_x) + Math.cos(angle) * (p_args[:y4] - p_anchor_y) + p_anchor_y;

        # Normalise the point sequence so we're always bottom left point first
        while new_x1 > new_x2 || new_x1 > new_x3 || new_x1 > new_x4 || ( new_x1 == new_x2 && new_y1 > new_y2 )
            tmp_x = new_x1
            tmp_y = new_y1
            new_x1 = new_x2
            new_y1 = new_y2
            new_x2 = new_x3
            new_y2 = new_y3
            new_x3 = new_x4
            new_y3 = new_y4
            new_x4 = tmp_x
            new_y4 = tmp_y
        end

        # Simply return the newly generated hash
        { x1: new_x1, x2: new_x2, x3: new_x3, x4: new_x4, y1: new_y1, y2: new_y2, y3: new_y3, y4: new_y4 }

    end

end


class AhnSprite


    # Pick up the attributes required to render as a sprite
    attr_sprite
    attr_accessor :z
    attr_accessor :sprites


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
        @angle = 0

        # Our primitive handlers
        @solids = AhnPrimitive.new @path, :solid
        @sprites = AhnPrimitive.new @path, :sprite
        @labels = AhnPrimitive.new @path, :label
        @lines = AhnPrimitive.new @path, :line
        @borders = AhnPrimitive.new @path, :border

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


    # Try to extract a collision box, based on the dimensions of primitives,
    # and the current position
    def boundaries

        # So, we'll return an array of rectangle hashes
        boxes = []

        # Get the solid and border boundaries
        boxes.concat @solids.boundaries @x, @y
        boxes.concat @borders.boundaries @x, @y
        boxes.concat @sprites.boundaries @x, @y

        # If the AhnSprite has been rotated, need to apply that to ALL the boundaries
        if @angle.nonzero?
            turned_boxes = []
            boxes.each { |box| turned_boxes << @sprites.rotate( box, angle, @x+@w/2, @y+@h/2 ) }
            return turned_boxes
        end

        # Hand back that big old array then
        boxes

    end

    # Draw the boundaries, only for debug purposes so shouldn't be rendered in production
    def render_bounds outputs
        boundaries.each do | box |
            outputs.debug << { x: box[:x1], y: box[:y1], w: 10, h: 10, r: 255, g: 0, b: 0 }.solid
            outputs.debug << { x: box[:x1], y: box[:y1], x2: box[:x2], y2: box[:y2], r: 255, g: 0, b: 0 }.line
            outputs.debug << { x: box[:x2], y: box[:y2], x2: box[:x3], y2: box[:y3], r: 255, g: 0, b: 0 }.line
            outputs.debug << { x: box[:x3], y: box[:y3], x2: box[:x4], y2: box[:y4], r: 255, g: 0, b: 0 }.line
            outputs.debug << { x: box[:x4], y: box[:y4], x2: box[:x1], y2: box[:y1], r: 255, g: 0, b: 0 }.line
        end
    end


    # Checks to see if we collide with another AhnSprite object
    def collides? target

        # Check that this is another AhnSprite, or none of this will make any sense
        if !target.kind_of? AhnSprite
            return false
        end

        # Fetch their boundaries
        their_borders = target.boundaries

        # Work through our own, comparing against each border in turn
        boundaries.each do | our_border |

            # Go through each target border
            their_borders.each do | their_border |

                # If both borders are unrotated, it's a simple check
                if our_border[:y1] == our_border[:y2] && their_border[:y1] == their_border[:y2]
                    if our_border[:x1] < their_border[:x2] && our_border[:x2] > their_border[:x1] && our_border[:y3] > their_border[:y1] && our_border[:y1] < their_border[:y3] 
                       return true
                    end
                end

                # Then we have do a much more complicated test

            end

        end

        # If we haven't returned with a hit, then there is no collision
        false

    end
        

end