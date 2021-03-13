function LayerData(name, sprite, blend_type, blend_src, blend_dest) constructor {
    self.name = name;
    self.sprite = sprite;
    self.blend_type = blend_type;
    self.blend_src = blend_src;
    self.blend_dest = blend_dest;
    
    self.Render = function() {
        if (sprite_exists(self.sprite)) {
            if (self.blend_type == BLEND_TYPE_DEFAULT) {
                gpu_set_blendmode(self.blend_src);
            } else {
                gpu_set_blendmode_ext(self.blend_src, self.blend_dest);
            }
            draw_sprite(self.sprite, 0, 0, 0);
        }
    };
    
    self.Destroy = function() {
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
    };
};

#macro BLEND_TYPE_DEFAULT 0
#macro BLEND_TYPE_ADVANCED 1