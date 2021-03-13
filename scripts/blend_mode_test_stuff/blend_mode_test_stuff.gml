function LayerData(name) constructor {
    self.name = name;
    self.sprite = -1;
    self.blend_type = BLEND_TYPE_DEFAULT;
    self.blend_single = bm_normal;
    self.blend_src = bm_zero;
    self.blend_dest = bm_one;
    self.enabled = true;
    
    self.Render = function() {
        if (self.enabled && sprite_exists(self.sprite)) {
            if (self.blend_type == BLEND_TYPE_DEFAULT) {
                gpu_set_blendmode(self.blend_single);
            } else {
                gpu_set_blendmode_ext(self.blend_src, self.blend_dest);
            }
            draw_sprite(self.sprite, 0, 0, 0);
        }
    };
    
    self.SetSprite = function(sprite) {
        if (sprite_exists(sprite)) {
            if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
            self.sprite = sprite;
        }
    };
    
    self.Destroy = function() {
        if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
    };
};

#macro BLEND_TYPE_DEFAULT 0
#macro BLEND_TYPE_ADVANCED 1

#macro BM_NORMAL 0
#macro BM_ADD 1
#macro BM_SUBTRACT 2
#macro BM_MAX 3

#macro BM_ZERO 0
#macro BM_ONE 1
#macro BM_SRC_COLOR 2
#macro BM_INV_SRC_COLOR 3
#macro BM_SRC_ALPHA 4
#macro BM_INV_SRC_ALPHA 5
#macro BM_DEST_ALPHA 6
#macro BM_INV_DEST_ALPHA 7
#macro BM_DEST_COLOR 8
#macro BM_INV_DEST_COLOR 9
#macro BM_SRC_ALPHA_SAT 10
