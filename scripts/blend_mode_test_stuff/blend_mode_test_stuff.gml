function LayerData(name) constructor {
    self.name = name;
    self.sprite = -1;
    self.blend_type = BLEND_TYPE_DEFAULT;
    self.blend_single = bm_normal;
    self.blend_src = bm_zero;
    self.blend_dest = bm_one;
    self.enabled = true;
    
    self.x = 0;
    self.y = 0;
    self.mx = undefined;
    self.my = undefined;
    self.width = 1;
    self.height = 1;
    
    self.Render = function(mx, my) {
        if (self.enabled && sprite_exists(self.sprite)) {
            if (self.blend_type == BLEND_TYPE_DEFAULT) {
                gpu_set_blendmode(self.blend_single);
            } else {
                gpu_set_blendmode_ext(self.blend_src, self.blend_dest);
            }
            draw_sprite_stretched(self.sprite, 0, self.x, self.y, self.width, self.height);
            if (obj_emu_demo.GetActiveLayer() == self) {
                var x1 = self.x;
                var y1 = self.y;
                var x2 = self.x + sprite_get_width(self.sprite) - 1;
                var y2 = self.y + sprite_get_height(self.sprite) - 1;
                if (obj_emu_demo.preview_borders) {
                    draw_rectangle_colour(x1, y1, x2, y2, c_white, c_white, c_white, c_white, true);
                }
                var within_sprite = point_in_rectangle(mx, my, max(0, x1), max(0, y1), min(self.width - 1, x2), min(self.height - 1, y2))
                if (abs(mx - x1) < 4 && my > min(y1, y2) && my < max(y1, y2)) {
                    window_set_cursor(cr_size_we);
                } else if (abs(mx - x2) < 4 && my > min(y1, y2) && my < max(y1, y2)) {
                    window_set_cursor(cr_size_we);
                } else if (abs(my - y1) < 4 && mx > min(x1, x2) && mx < max(x1, x2)) {
                    window_set_cursor(cr_size_ns);
                } else if (abs(my - y2) < 4 && mx > min(x1, x2) && mx < max(x1, x2)) {
                    window_set_cursor(cr_size_ns);
                } else if (within_sprite) {
                    window_set_cursor(cr_size_all);
                } else {
                    window_set_cursor(cr_default);
                }
                if (mouse_check_button_pressed(mb_left)) {
                    if (within_sprite) {
                        self.mx = mx;
                        self.my = my;
                    }
                } else if (mouse_check_button_released(mb_left)) {
                    self.mx = undefined;
                    self.my = undefined;
                } else if (mouse_check_button(mb_left)) {
                    if (self.mx != undefined) {
                        self.x += (mx - self.mx);
                        self.y += (my - self.my);
                        self.mx = mx;
                        self.my = my;
                    }
                }
            }
        }
    };
    
    self.SetSprite = function(sprite) {
        if (sprite_exists(sprite)) {
            if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
            self.sprite = sprite;
            self.width = sprite_get_width(sprite);
            self.height = sprite_get_height(sprite);
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
