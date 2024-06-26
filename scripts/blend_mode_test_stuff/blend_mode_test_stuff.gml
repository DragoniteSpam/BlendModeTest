function LayerData(name) constructor {
    self.name = name;
    self.sprite = -1;
    self.blend_type = BLEND_TYPE_DEFAULT;
    self.blend_single = bm_normal;
    self.blend_src = bm_zero;
    self.blend_dest = bm_one;
    self.blend_alpha_src = bm_zero;
    self.blend_alpha_dest = bm_one;
	self.blend_equation = bm_eq_add;
	self.blend_equation_alpha = bm_eq_add;
    self.enabled = true;
    
    static drag_mode_none = 0;
    static drag_mode_pan = 1;
    static drag_mode_n = 2;
    static drag_mode_s = 3;
    static drag_mode_e = 4;
    static drag_mode_w = 5;
    static drag_mode_nw = 6;
    static drag_mode_ne = 7;
    static drag_mode_sw = 8;
    static drag_mode_se = 9;
    
    self.x = 0;
    self.y = 0;
    self.mx = 0;
    self.my = 0;
    self.width = 1;
    self.height = 1;
    self.drag_mode = drag_mode_none;
    self.locked_drag_mode = self.drag_mode;
    
    self.Reset = function() {
        self.x = 0;
        self.y = 0;
        self.mx = 0;
        self.my = 0;
        self.width = 1;
        self.height = 1;
        self.drag_mode = drag_mode_none;
        self.locked_drag_mode = self.drag_mode;
        if (sprite_exists(self.sprite)) {
            self.width = sprite_get_width(self.sprite);
            self.height = sprite_get_height(self.sprite);
        }
        self.blend_type = BLEND_TYPE_DEFAULT;
        self.blend_single = bm_normal;
        self.blend_src = bm_zero;
        self.blend_dest = bm_one;
        self.blend_alpha_src = bm_zero;
        self.blend_alpha_dest = bm_one;
		self.blend_equation = bm_eq_add;
		self.blend_equation_alpha = bm_eq_add;
        obj_emu_demo.Refresh();
    };
    
    self.Render = function(mx, my) {
        if (self.enabled && sprite_exists(self.sprite)) {
            if (obj_emu_demo.GetActiveLayer() == self) {
                var x1 = self.x;
                var y1 = self.y;
                var x2 = self.x + self.width - 1;
                var y2 = self.y + self.height - 1;
                var ax1 = min(x1, x2);
                var ay1 = min(y1, y2);
                var ax2 = max(x1, x2);
                var ay2 = max(y1, y2);
                var within_sprite = point_in_rectangle(mx, my, max(0, ax1), max(0, ay1), min(obj_emu_demo.render_surface.width - 1, ax2), min(obj_emu_demo.render_surface.height - 1, ay2))
                if (self.locked_drag_mode == drag_mode_none) {
                    if (abs(mx - ax1) < 4 && abs(my - ay1) < 4) {
                        window_set_cursor(cr_size_nwse);
                        self.drag_mode = drag_mode_nw;
                    } else if (abs(mx - ax2) < 4 && abs(my - ay1) < 4) {
                        window_set_cursor(cr_size_nesw);
                        self.drag_mode = drag_mode_ne;
                    } else if (abs(mx - ax1) < 4 && abs(my - ay2) < 4) {
                        window_set_cursor(cr_size_nesw);
                        self.drag_mode = drag_mode_sw;
                    } else if (abs(mx - ax2) < 4 && abs(my - ay2) < 4) {
                        window_set_cursor(cr_size_nwse);
                        self.drag_mode = drag_mode_se;
                    } else if (abs(mx - ax1) < 4 && my > ay1 && my < ay2) {
                        window_set_cursor(cr_size_we);
                        self.drag_mode = drag_mode_w;
                    } else if (abs(mx - ax2) < 4 && my > ay1 && my < ay2) {
                        window_set_cursor(cr_size_we);
                        self.drag_mode = drag_mode_e;
                    } else if (abs(my - ay1) < 4 && mx > ax1 && mx < ax2) {
                        window_set_cursor(cr_size_ns);
                        self.drag_mode = drag_mode_n;
                    } else if (abs(my - ay2) < 4 && mx > ax1 && mx < ax2) {
                        window_set_cursor(cr_size_ns);
                        self.drag_mode = drag_mode_s;
                    } else if (within_sprite) {
                        window_set_cursor(cr_size_all);
                        self.drag_mode = drag_mode_pan;
                    } else {
                        window_set_cursor(cr_default);
                    }
                }
                if (mouse_check_button_pressed(mb_left)) {
                    self.locked_drag_mode = self.drag_mode;
                    if (self.drag_mode != drag_mode_none) {
                        self.mx = mx;
                        self.my = my;
                    }
                } else if (mouse_check_button_released(mb_left)) {
                    self.drag_mode = drag_mode_none;
                } else if (mouse_check_button(mb_left)) {
                    if (self.drag_mode == drag_mode_pan) {
                        self.x += (mx - self.mx);
                        self.y += (my - self.my);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_e) {
                        self.width += (mx - self.mx);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_w) {
                        self.width -= (mx - self.mx);
                        self.x += (mx - self.mx);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_n) {
                        self.height -= (my - self.my);
                        self.y += (my - self.my);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_s) {
                        self.height += (my - self.my);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_nw) {
                        self.height -= (my - self.my);
                        self.y += (my - self.my);
                        self.width -= (mx - self.mx);
                        self.x += (mx - self.mx);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_ne) {
                        self.height -= (my - self.my);
                        self.y += (my - self.my);
                        self.width += (mx - self.mx);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_sw) {
                        self.height += (my - self.my);
                        self.width -= (mx - self.mx);
                        self.x += (mx - self.mx);
                        self.mx = mx;
                        self.my = my;
                    } else if (self.drag_mode == drag_mode_se) {
                        self.height += (my - self.my);
                        self.width += (mx - self.mx);
                        self.mx = mx;
                        self.my = my;
                    }
                } else {
                    self.locked_drag_mode = drag_mode_none;
                }
            }
            
            if (self.blend_type == BLEND_TYPE_DEFAULT) {
                gpu_set_blendmode(self.blend_single);
            } else if (self.blend_type == BLEND_TYPE_MORE_ADVANCED) {
                gpu_set_blendmode_ext_sepalpha(self.blend_src, self.blend_dest, self.blend_alpha_src, self.blend_alpha_dest);
            } else {
                gpu_set_blendmode_ext(self.blend_src, self.blend_dest);
            }
			gpu_set_blendequation_sepalpha(self.blend_equation, self.blend_equation_alpha);
            draw_sprite_stretched(self.sprite, 0, self.x, self.y, self.width, self.height);
			gpu_set_blendequation(bm_eq_add);
            if (obj_emu_demo.GetActiveLayer() == self) {
                var x1 = self.x;
                var y1 = self.y;
                var x2 = self.x + self.width - 1;
                var y2 = self.y + self.height - 1;
                if (obj_emu_demo.preview_borders) {
                    gpu_set_blendmode_ext(bm_inv_dest_color, bm_inv_src_alpha);
                    draw_rectangle_colour(x1, y1, x2, y2, c_white, c_white, c_white, c_white, true);
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

#macro BLEND_TYPE_DEFAULT		0
#macro BLEND_TYPE_ADVANCED		1
#macro BLEND_TYPE_MORE_ADVANCED 2

#macro BE_ADD					0
#macro BE_SUBTRACT				1
#macro BE_REVERSE_SUBTRACT		2
#macro BE_MIN					3
#macro BE_MAX					4

#macro BM_NORMAL				0
#macro BM_ADD					1
#macro BM_SUBTRACT				2
#macro BM_MAX					3

#macro BM_ZERO					0
#macro BM_ONE					1
#macro BM_SRC_COLOR				2
#macro BM_INV_SRC_COLOR			3
#macro BM_SRC_ALPHA				4
#macro BM_INV_SRC_ALPHA			5
#macro BM_DEST_ALPHA			6
#macro BM_INV_DEST_ALPHA		7
#macro BM_DEST_COLOR			8
#macro BM_INV_DEST_COLOR		9
#macro BM_SRC_ALPHA_SAT			10

global.lookup_basic_to_index = { };
global.lookup_basic_to_index[$ bm_normal] = BM_NORMAL;
global.lookup_basic_to_index[$ bm_add] = BM_ADD;
global.lookup_basic_to_index[$ bm_subtract] = BM_SUBTRACT;
global.lookup_basic_to_index[$ bm_max] = BM_MAX;

global.lookup_index_to_basic = { };
global.lookup_index_to_basic[$ BM_NORMAL] = bm_normal;
global.lookup_index_to_basic[$ BM_ADD] = bm_add;
global.lookup_index_to_basic[$ BM_SUBTRACT] = bm_subtract;
global.lookup_index_to_basic[$ BM_MAX] = bm_max;

global.lookup_equation_to_index = { };
global.lookup_equation_to_index[$ bm_eq_add] = BE_ADD;
global.lookup_equation_to_index[$ bm_eq_subtract] = BE_SUBTRACT;
global.lookup_equation_to_index[$ bm_eq_reverse_subtract] = BE_REVERSE_SUBTRACT;
global.lookup_equation_to_index[$ bm_eq_min] = BE_MIN;
global.lookup_equation_to_index[$ bm_eq_max] = BE_MAX;

global.lookup_index_to_equation = { };
global.lookup_index_to_equation[$ BE_ADD] = bm_eq_add;
global.lookup_index_to_equation[$ BE_SUBTRACT] = bm_eq_subtract;
global.lookup_index_to_equation[$ BE_REVERSE_SUBTRACT] = bm_eq_reverse_subtract;
global.lookup_index_to_equation[$ BE_MIN] = bm_eq_min;
global.lookup_index_to_equation[$ BE_MAX] = bm_eq_max;

global.lookup_ext_to_index = { };
global.lookup_ext_to_index[$ bm_zero] = BM_ZERO;
global.lookup_ext_to_index[$ bm_one] = BM_ONE;
global.lookup_ext_to_index[$ bm_src_color] = BM_SRC_COLOR;
global.lookup_ext_to_index[$ bm_inv_src_color] = BM_INV_SRC_COLOR;
global.lookup_ext_to_index[$ bm_src_alpha] = BM_SRC_ALPHA;
global.lookup_ext_to_index[$ bm_inv_src_alpha] = BM_INV_SRC_ALPHA;
global.lookup_ext_to_index[$ bm_dest_alpha] = BM_DEST_ALPHA;
global.lookup_ext_to_index[$ bm_inv_dest_alpha] = BM_INV_DEST_ALPHA;
global.lookup_ext_to_index[$ bm_dest_color] = BM_DEST_COLOR;
global.lookup_ext_to_index[$ bm_inv_dest_color] = BM_INV_DEST_COLOR;
global.lookup_ext_to_index[$ bm_src_alpha_sat] = BM_SRC_ALPHA_SAT;

global.lookup_index_to_ext = { };
global.lookup_index_to_ext[$ BM_ZERO] = bm_zero;
global.lookup_index_to_ext[$ BM_ONE] = bm_one;
global.lookup_index_to_ext[$ BM_SRC_COLOR] = bm_src_color;
global.lookup_index_to_ext[$ BM_INV_SRC_COLOR] = bm_inv_src_color;
global.lookup_index_to_ext[$ BM_SRC_ALPHA] = bm_src_alpha;
global.lookup_index_to_ext[$ BM_INV_SRC_ALPHA] = bm_inv_src_alpha;
global.lookup_index_to_ext[$ BM_DEST_ALPHA] = bm_dest_alpha;
global.lookup_index_to_ext[$ BM_INV_DEST_ALPHA] = bm_inv_dest_alpha;
global.lookup_index_to_ext[$ BM_DEST_COLOR] = bm_dest_color;
global.lookup_index_to_ext[$ BM_INV_DEST_COLOR] = bm_inv_dest_color;
global.lookup_index_to_ext[$ BM_SRC_ALPHA_SAT] = bm_src_alpha_sat;