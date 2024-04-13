#macro ELEMENT_WIDTH 264
#macro ELEMENT_HEIGHT 24
#macro COL1_X 16
#macro COL2_X 304
#macro ELEMENT_SPACING 8

layers = [];
preview_background_color = c_black;
preview_export_opaque = false;
preview_borders = true;

container = new EmuCore(32, 32, 640, 640);
container._element_spacing_y = ELEMENT_SPACING;

Select = function(layer) {
    if (layer == undefined) {
        layer_name.SetInteractive(false);
        layer_enabled.SetInteractive(false);
        layer_delete.SetInteractive(false);
        layer_move_up.SetInteractive(false);
        layer_move_down.SetInteractive(false);
        array_blend_type.SetInteractive(false);
        array_blend_mode_basic.SetInteractive(false);
        array_blend_mode_ext_src.SetInteractive(false);
        array_blend_mode_ext_dest.SetInteractive(false);
        array_blend_mode_sep_alpha.SetInteractive(false);
        load_image_button.SetInteractive(false);
        layer_reset.SetInteractive(false);
        layer_presets.SetInteractive(false);
		array_blend_equation.SetInteractive(false);
		array_blend_equation_alpha.SetInteractive(false);
    } else {
        var layer_data = layers[layer];
        layer_name.SetInteractive(true);
        layer_name.SetValue(layer_data.name);
        layer_enabled.SetInteractive(true);
        layer_enabled.SetValue(layer_data.enabled);
        layer_delete.SetInteractive(true);
        layer_move_up.SetInteractive(layer > 0);
        layer_move_down.SetInteractive(layer < array_length(layers) - 1);
        array_blend_type.SetInteractive(true);
        array_blend_type.SetValue(layer_data.blend_type);
        load_image_button.SetInteractive(true);
        layer_reset.SetInteractive(true);
        layer_presets.SetInteractive(true);
		array_blend_equation.SetInteractive(true);
		array_blend_equation_alpha.SetInteractive(true);
		array_blend_equation.SetValue(global.lookup_equation_to_index[$ layer_data.blend_equation]);
		array_blend_equation_alpha.SetValue(global.lookup_equation_to_index[$ layer_data.blend_equation_alpha]);
        if (layer_data.blend_type == BLEND_TYPE_DEFAULT) {
            array_blend_mode_basic.SetInteractive(true);
            array_blend_mode_basic.SetValue(global.lookup_basic_to_index[$ layer_data.blend_single]);
            array_blend_mode_ext_src.SetInteractive(false);
            array_blend_mode_ext_dest.SetInteractive(false);
            array_blend_mode_sep_alpha.SetInteractive(false);
        } else if (layer_data.blend_type == BLEND_TYPE_ADVANCED) {
            array_blend_mode_basic.SetInteractive(false);
            array_blend_mode_ext_src.SetInteractive(true);
            array_blend_mode_ext_src.SetValue(global.lookup_ext_to_index[$ layer_data.blend_src]);
            array_blend_mode_ext_dest.SetInteractive(true);
            array_blend_mode_ext_dest.SetValue(global.lookup_ext_to_index[$ layer_data.blend_dest]);
            array_blend_mode_sep_alpha.SetInteractive(false);
        } else if (layer_data.blend_type == BLEND_TYPE_MORE_ADVANCED) {
            array_blend_mode_basic.SetInteractive(false);
            array_blend_mode_ext_src.SetInteractive(true);
            array_blend_mode_ext_src.SetValue(global.lookup_ext_to_index[$ layer_data.blend_src]);
            array_blend_mode_ext_dest.SetInteractive(true);
            array_blend_mode_ext_dest.SetValue(global.lookup_ext_to_index[$ layer_data.blend_dest]);
            array_blend_mode_sep_alpha.SetInteractive(true);
        }
        load_image_button.sprite = layer_data.sprite;
        load_image_button.alignment = fa_left;
        load_image_button.valignment = fa_top;
    }
    if (array_length(layers) == 255) {
        layer_add.SetInteractive(false);
    } else {
        layer_add.SetInteractive(true);
    }
};

Refresh = function() {
    var selection = layer_list.GetSelection();
    if (selection == -1) {
        if (array_length(layers) > 0) {
            selection = array_length(layers) - 1;
            layer_list.Select(selection);
            return;
        } else {
            selection = undefined;
        }
    }
    Select(selection);
};

SetExt = function(src, dest) {
    var layer_data = self.GetActiveLayer();
    layer_data.blend_type = BLEND_TYPE_ADVANCED;
    layer_data.blend_src = src;
    layer_data.blend_dest = dest;
    self.array_blend_type.value = 1;
    self.Refresh();
};

layer_list = new EmuList(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Layers:", ELEMENT_HEIGHT, 16, function() { });
layer_list.SetList(layers);
layer_list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
layer_list.allow_deselect = false;
layer_list.getListColors = method(layer_list, function(index) {
    return obj_emu_demo.layers[index].enabled ? EMU_COLOR_LIST_TEXT : EMU_COLOR_INPUT_REJECT;
});
layer_list.SetCallbackMiddle(function(index) {
    obj_emu_demo.GetActiveLayer().enabled = !obj_emu_demo.GetActiveLayer().enabled;
    obj_emu_demo.Refresh();
});

GetActiveLayer = function() {
	var selected = layer_list.GetSelection();
	if (selected == -1) return undefined;
	return layers[selected];
};

layer_add = new EmuButton(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Add Layer", function() {
    var n = array_length(obj_emu_demo.layers);
	var selection = obj_emu_demo.layer_list.GetSelection();
	if (selection != -1) {
		array_insert(obj_emu_demo.layers, selection, new LayerData("Layer" + string(n)));
	} else {
		array_push(obj_emu_demo.layers, new LayerData("Layer" + string(n)));
	}
    if (n == 0) {
        obj_emu_demo.layer_list.Select(0, true);
    } else {
        obj_emu_demo.Refresh();
    }
});

layer_enabled = new EmuCheckbox(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Visible?", true, function() {
    obj_emu_demo.GetActiveLayer().enabled = value;
});
layer_enabled.SetInteractive(false);

layer_name = new EmuInput(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Layer Name:", "", "name", 32, E_InputTypes.STRING, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.name = value;
});
layer_name.SetInteractive(false);

layer_delete = new EmuButton(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Delete Layer", function() {
    var selection = obj_emu_demo.layer_list.GetSelection();
    obj_emu_demo.layers[selection].Destroy();
    array_delete(obj_emu_demo.layers, selection, 1);
    obj_emu_demo.layer_list.ClearSelection();
    if (selection < array_length(obj_emu_demo.layers)) {
        obj_emu_demo.layer_list.Select(selection, true);
    }
    obj_emu_demo.layer_add.interactive = true;
});
layer_delete.SetInteractive(false);

// these two are confusing because moving up involves decreasing your position in the list
layer_move_up = new EmuButton(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Move Layer Up", function() {
    var index = obj_emu_demo.layer_list.GetSelection();
    var t = obj_emu_demo.layers[index];
    obj_emu_demo.layers[index] = obj_emu_demo.layers[index - 1];
    obj_emu_demo.layers[index - 1] = t;
    obj_emu_demo.layer_list.ClearSelection();
    obj_emu_demo.layer_list.Select(index - 1, true);
});
layer_move_up.SetInteractive(false);

layer_move_down = new EmuButton(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Move Layer Down", function() {
    var index = obj_emu_demo.layer_list.GetSelection();
    var t = obj_emu_demo.layers[index];
    obj_emu_demo.layers[index] = obj_emu_demo.layers[index + 1];
    obj_emu_demo.layers[index + 1] = t;
    obj_emu_demo.layer_list.ClearSelection();
    obj_emu_demo.layer_list.Select(index + 1, true);
});
layer_move_down.SetInteractive(false);

container.AddContent([
    new EmuText(COL1_X, 0, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Blend Mode Test Program"),
    layer_list,
    layer_add,
    layer_enabled,
    layer_name,
    layer_delete,
    layer_move_up,
    layer_move_down,
]);

array_blend_type = new EmuRadioArray(COL2_X, 0, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Blend Type:", BLEND_TYPE_DEFAULT, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    switch (value) {
        case 0: layer_data.blend_type = BLEND_TYPE_DEFAULT; break;
        case 1: layer_data.blend_type = BLEND_TYPE_ADVANCED; break;
        case 2: layer_data.blend_type = BLEND_TYPE_MORE_ADVANCED; break;
    }
    obj_emu_demo.Refresh();
});
array_blend_type.AddOptions(["Basic", "Extended", "Separate Alpha"]);
array_blend_type.SetColumns(2, 192);
array_blend_type.SetInteractive(false);

array_blend_mode_basic = new EmuRadioArray(COL2_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Basic Types:", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.blend_single = global.lookup_index_to_basic[$ self.value];
});
array_blend_mode_basic.AddOptions(["Normal", "Add", "Subtract", "Max"]);
array_blend_mode_basic.SetColumns(2, 192);
array_blend_mode_basic.SetInteractive(false);

array_blend_mode_ext_src = new EmuRadioArray(COL2_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Extended Types (Source):", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.blend_src = global.lookup_index_to_ext[$ self.value];
});
array_blend_mode_ext_src.AddOptions(["Zero", "One", "Src Color", "Inv Src Color", "Src Alpha", "Inv Src Alpha", "Dest Alpha", "Inv Dest Alpha", "Dest Color", "Inv Dest Color", "Src Alpha Sat"]);
array_blend_mode_ext_src.SetColumns(4, 128);
array_blend_mode_ext_src.SetInteractive(false);

array_blend_mode_ext_dest = new EmuRadioArray(COL2_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Extended Types (Destination):", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.blend_dest = global.lookup_index_to_ext[$ self.value];
});
array_blend_mode_ext_dest.AddOptions(["Zero", "One", "Src Color", "Inv Src Color", "Src Alpha", "Inv Src Alpha", "Dest Alpha", "Inv Dest Alpha", "Dest Color", "Inv Dest Color", "Src Alpha Sat"]);
array_blend_mode_ext_dest.SetColumns(4, 128);
array_blend_mode_ext_dest.SetInteractive(false);

array_blend_mode_sep_alpha = new EmuButton(COL2_X, EMU_AUTO, 192, ELEMENT_HEIGHT, "Separate Alpha...", function() {
    var dialog = new EmuDialog(480, 560, "Alpha Modes");
    
    dialog.AddContent([
        new EmuRadioArray(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Extended Types (Source):", 0, function() {
            var layer_data = obj_emu_demo.GetActiveLayer();
            layer_data.blend_alpha_src = variable_struct_get(global.lookup_index_to_ext, self.value);
        })
            .AddOptions(["Zero", "One", "Src Color", "Inv Src Color", "Src Alpha", "Inv Src Alpha", "Dest Alpha", "Inv Dest Alpha", "Dest Color", "Inv Dest Color", "Src Alpha Sat"])
            .SetColumns(6, 192),
        new EmuRadioArray(COL1_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Extended Types (Destination):", 0, function() {
            var layer_data = obj_emu_demo.GetActiveLayer();
            layer_data.blend_alpha_dest = variable_struct_get(global.lookup_index_to_ext, self.value);
        })
            .AddOptions(["Zero", "One", "Src Color", "Inv Src Color", "Src Alpha", "Inv Src Alpha", "Dest Alpha", "Inv Dest Alpha", "Dest Color", "Inv Dest Color", "Src Alpha Sat"])
            .SetColumns(6, 192),
    ]);
});
array_blend_mode_sep_alpha.SetInteractive(false);

array_blend_equation = new EmuRadioArray(COL2_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Blend Equation:", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
	layer_data.blend_equation = global.lookup_index_to_equation[$ value];
    obj_emu_demo.Refresh();
});
array_blend_equation.AddOptions(["Add", "Subtract", "Inv Subtract", "Min", "Max"]);
array_blend_equation.SetColumns(2, 128);
array_blend_equation.SetInteractive(false);

array_blend_equation_alpha = new EmuRadioArray(COL2_X, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Blend Equation (Alpha):", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
	layer_data.blend_equation_alpha = global.lookup_index_to_equation[$ value];
    obj_emu_demo.Refresh();
});
array_blend_equation_alpha.AddOptions(["Add", "Subtract", "Inv Subtract", "Min", "Max"]);
array_blend_equation_alpha.SetColumns(2, 128);
array_blend_equation_alpha.SetInteractive(false);

container.AddContent([
    array_blend_type,
    array_blend_mode_basic,
    array_blend_mode_ext_src,
    array_blend_mode_ext_dest,
    array_blend_mode_sep_alpha
]);

layer_presets = new EmuButton(COL2_X + 192 + 16, array_blend_mode_sep_alpha.y, 192, ELEMENT_HEIGHT, "Presets", function() {
    var dialog = new EmuDialog(320, 280, "Preset Blend Modes");
    dialog._element_spacing_y = ELEMENT_SPACING;
    dialog.AddContent([
        new EmuButton(32, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Multiply", function() {
            obj_emu_demo.SetExt(bm_dest_color, bm_inv_src_alpha);
            self.root.Close();
        }),
        new EmuButton(32, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Screen", function() {
            obj_emu_demo.SetExt(bm_one, bm_inv_src_color);
            self.root.Close();
        }),
        new EmuButton(32, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Linear Dodge", function() {
            obj_emu_demo.SetExt(bm_one, bm_one);
            self.root.Close();
        }),
        new EmuButton(32, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Back", function() {
            self.root.Close();
        }),
    ]);
    dialog.active_shade = false;
});
layer_presets.SetInteractive(false);

container.AddContent([
	layer_presets,
	array_blend_equation,
	array_blend_equation_alpha
]);

layer_reset = new EmuButton(COL2_X, EMU_AUTO, 400, ELEMENT_HEIGHT, "Reset Layer", function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.Reset();
});
layer_reset.SetInteractive(false);

container.AddContent(layer_reset);

load_image_button = new EmuButtonImage(736, EMU_AUTO, 128, 128, -1, 0, c_white, 1, true, function() {
    var sprite_fn = get_open_filename("Image files|*.png;*.bmp;*jpg;*.jpeg;*", "Select an image");
    obj_emu_demo.GetActiveLayer().SetSprite(sprite_add(sprite_fn, 0, false, false, 0, 0));
    obj_emu_demo.Refresh();
});
load_image_button.alt_text = "Click to load";
load_image_button.SetInteractive(false);

render_surface = new EmuRenderSurface(736, 0, 540, 540, function(mx, my) {
    gpu_set_colorwriteenable(true, true, true, false);
    if (obj_emu_demo.preview_export_opaque) {
        draw_clear(obj_emu_demo.preview_background_color);
    } else {
        drawCheckerbox(0, 0, width, height, 1, 1, c_white, 1);
    }
    for (var i = array_length(obj_emu_demo.layers) - 1; i >= 0; i--) {
        obj_emu_demo.layers[i].Render(mx, my);
    }
    gpu_set_blendmode(bm_normal);
    gpu_set_colorwriteenable(true, true, true, true);
}, function(mx, my) { }, function() { }, function() { });

container.AddContent([
    render_surface,
    load_image_button,
]);

var button_export = new EmuButton(732 + 128 + 32, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Export Image", function() {
    var fn = get_save_filename("PNG files|*.png", "save.png");
    if (fn != "") {
        var t_borders = obj_emu_demo.preview_borders;
        obj_emu_demo.preview_borders = false;
        var render_surface = obj_emu_demo.render_surface;
        
        render_surface.Render(0, 0);
        
        var surface = surface_create(render_surface.width, render_surface.height);
        surface_set_target(surface);
        draw_clear_alpha(c_white, 1);
        
        shader_set(shd_noalpha);
        draw_surface(render_surface._surface, 0, 0);
        shader_reset();
        
        surface_reset_target();
        surface_save(surface, fn);
        surface_free(surface);
        
        obj_emu_demo.preview_borders = t_borders;
    }
});

var button_credits = new EmuButton(732 + 128 + 32, EMU_AUTO, ELEMENT_WIDTH, ELEMENT_HEIGHT, "Credits", function() {
    var dialog = new EmuDialog(640, 320, "Credits");
    dialog._element_spacing_y = ELEMENT_SPACING;
    dialog.AddContent([
        new EmuText(dialog.width / 2, EMU_AUTO, 560, 64, "[c_blue][fa_center]Blend Mode Testing, by @dragonitespam[]"),
        new EmuText(32, EMU_AUTO, 560, 32, "The [rainbow][wave]Scribble[/wave][/rainbow]  text renderer is by @jujuadams"),
        new EmuText(32, EMU_AUTO, 560, 32, "The icon is \"blend\" by Adnen Kadri from the Noun Project"),
        new EmuButton(dialog.width / 2 - 128 / 2, dialog.height - 32 - 32 / 2, 128, 32, "Close", emu_dialog_close_auto),
    ]);
});

container.AddContent([
    new EmuColorPicker(732 + 128 + 32, load_image_button.y, 384, ELEMENT_HEIGHT, "Background color:", preview_background_color, function() {
        obj_emu_demo.preview_background_color = value;
    }),
    button_export,
    button_credits,
]);

container.AddContent([
    new EmuCheckbox(732 + 128 + 256 + 32, button_export.y, 128, ELEMENT_HEIGHT, "Opaque?", preview_export_opaque, function() {
        obj_emu_demo.preview_export_opaque = value;
    }),
    new EmuCheckbox(732 + 128 + 256 + 32, button_credits.y, 128, ELEMENT_HEIGHT, "Borders?", preview_borders, function() {
        obj_emu_demo.preview_borders = value;
    }),
]);

layer_list.SetCallback(function() {
    var selection = GetSelection();
    if (selection == -1) {
        obj_emu_demo.Select(undefined);
    } else {
        obj_emu_demo.Select(GetSelection());
    }
});