layers = ds_list_create();
preview_background_color = c_black;
preview_export_opaque = false;
preview_borders = true;

container = new EmuCore(32, 32, 640, 640);

lookup_basic_to_index = { };
lookup_basic_to_index[$ bm_normal] = BM_NORMAL;
lookup_basic_to_index[$ bm_add] = BM_ADD;
lookup_basic_to_index[$ bm_subtract] = BM_SUBTRACT;
lookup_basic_to_index[$ bm_max] = BM_MAX;

lookup_index_to_basic = { };
lookup_index_to_basic[$ BM_NORMAL] = bm_normal;
lookup_index_to_basic[$ BM_ADD] = bm_add;
lookup_index_to_basic[$ BM_SUBTRACT] = bm_subtract;
lookup_index_to_basic[$ BM_MAX] = bm_max;

lookup_ext_to_index = { };
lookup_ext_to_index[$ bm_zero] = BM_ZERO;
lookup_ext_to_index[$ bm_one] = BM_ONE;
lookup_ext_to_index[$ bm_src_color] = BM_SRC_COLOR;
lookup_ext_to_index[$ bm_inv_src_color] = BM_INV_SRC_COLOR;
lookup_ext_to_index[$ bm_src_alpha] = BM_SRC_ALPHA;
lookup_ext_to_index[$ bm_inv_src_alpha] = BM_INV_SRC_ALPHA;
lookup_ext_to_index[$ bm_dest_alpha] = BM_DEST_ALPHA;
lookup_ext_to_index[$ bm_inv_dest_alpha] = BM_INV_DEST_ALPHA;
lookup_ext_to_index[$ bm_dest_color] = BM_DEST_COLOR;
lookup_ext_to_index[$ bm_inv_dest_color] = BM_INV_DEST_COLOR;
lookup_ext_to_index[$ bm_src_alpha_sat] = BM_SRC_ALPHA_SAT;

lookup_index_to_ext = { };
lookup_index_to_ext[$ BM_ZERO] = bm_zero;
lookup_index_to_ext[$ BM_ONE] = bm_one;
lookup_index_to_ext[$ BM_SRC_COLOR] = bm_src_color;
lookup_index_to_ext[$ BM_INV_SRC_COLOR] = bm_inv_src_color;
lookup_index_to_ext[$ BM_SRC_ALPHA] = bm_src_alpha;
lookup_index_to_ext[$ BM_INV_SRC_ALPHA] = bm_inv_src_alpha;
lookup_index_to_ext[$ BM_DEST_ALPHA] = bm_dest_alpha;
lookup_index_to_ext[$ BM_INV_DEST_ALPHA] = bm_inv_dest_alpha;
lookup_index_to_ext[$ BM_DEST_COLOR] = bm_dest_color;
lookup_index_to_ext[$ BM_INV_DEST_COLOR] = bm_inv_dest_color;
lookup_index_to_ext[$ BM_SRC_ALPHA_SAT] = bm_src_alpha_sat;

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
        load_image_button.SetInteractive(false);
    } else {
        var layer_data = layers[| layer];
        layer_name.SetInteractive(true);
        layer_name.SetValue(layer_data.name);
        layer_enabled.SetInteractive(true);
        layer_enabled.SetValue(layer_data.enabled);
        layer_delete.SetInteractive(true);
        layer_move_up.SetInteractive(layer > 0);
        layer_move_down.SetInteractive(layer < ds_list_size(layers) - 1);
        array_blend_type.SetInteractive(true);
        array_blend_type.SetValue(layer_data.blend_type);
        load_image_button.SetInteractive(true);
        if (layer_data.blend_type == BLEND_TYPE_DEFAULT) {
            array_blend_mode_basic.SetInteractive(true);
            array_blend_mode_basic.SetValue(lookup_basic_to_index[$ layer_data.blend_single]);
            array_blend_mode_ext_src.SetInteractive(false);
            array_blend_mode_ext_dest.SetInteractive(false);
        } else if (layer_data.blend_type == BLEND_TYPE_ADVANCED) {
            array_blend_mode_basic.SetInteractive(false);
            array_blend_mode_ext_src.SetInteractive(true);
            array_blend_mode_ext_src.SetValue(lookup_ext_to_index[$ layer_data.blend_src]);
            array_blend_mode_ext_dest.SetInteractive(true);
            array_blend_mode_ext_dest.SetValue(lookup_ext_to_index[$ layer_data.blend_dest]);
        }
        load_image_button.sprite = layer_data.sprite;
        load_image_button.alignment = fa_left;
        load_image_button.valignment = fa_top;
    }
    if (ds_list_size(layers) == 255) {
        layer_add.SetInteractive(false);
    } else {
        layer_add.SetInteractive(true);
    }
};

Refresh = function() {
    Select(layer_list.GetSelection());
};

layer_list = new EmuList(32, EMU_AUTO, 256, 32, "Layers:", 32, 10, function() { });
layer_list.SetList(layers);
layer_list.SetEntryTypes(E_ListEntryTypes.STRUCTS);
layer_list.allow_deselect = false;
layer_list.getListColors = method(layer_list, function(index) {
    return obj_emu_demo.layers[| index].enabled ? EMU_COLOR_LIST_TEXT : EMU_COLOR_INPUT_REJECT;
});
layer_list.SetCallbackMiddle(function(index) {
    obj_emu_demo.GetActiveLayer().enabled = !obj_emu_demo.GetActiveLayer().enabled;
    obj_emu_demo.Refresh();
});

GetActiveLayer = function() {
    return layers[| layer_list.GetSelection()];
};

layer_add = new EmuButton(32, EMU_AUTO, 256, 32, "Add Layer", function() {
    var n = ds_list_size(obj_emu_demo.layers);
    ds_list_add(obj_emu_demo.layers, new LayerData("Layer" + string(n)));
    if (n == 0) {
        obj_emu_demo.layer_list.Select(0, true);
    } else {
        obj_emu_demo.Refresh();
    }
});

layer_enabled = new EmuCheckbox(32, EMU_AUTO, 256, 32, "Visible?", true, function() {
    obj_emu_demo.GetActiveLayer().enabled = value;
});
layer_enabled.SetInteractive(false);

layer_name = new EmuInput(32, EMU_AUTO, 256, 32, "Layer Name:", "", "name", 32, E_InputTypes.STRING, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.name = value;
});
layer_name.SetInteractive(false);

layer_delete = new EmuButton(32, EMU_AUTO, 256, 32, "Delete Layer", function() {
    var selection = obj_emu_demo.layer_list.GetSelection();
    obj_emu_demo.layers[| selection].Destroy();
    ds_list_delete(obj_emu_demo.layers, selection);
    obj_emu_demo.layer_list.ClearSelection();
    if (selection < ds_list_size(obj_emu_demo.layers)) {
        obj_emu_demo.layer_list.Select(selection, true);
    }
});
layer_delete.SetInteractive(false);

// these two are confusing because moving up involves decreasing your position in the list
layer_move_up = new EmuButton(32, EMU_AUTO, 256, 32, "Move Layer Up", function() {
    var index = obj_emu_demo.layer_list.GetSelection();
    var t = obj_emu_demo.layers[| index];
    obj_emu_demo.layers[| index] = obj_emu_demo.layers[| index - 1];
    obj_emu_demo.layers[| index - 1] = t;
    obj_emu_demo.layer_list.ClearSelection();
    obj_emu_demo.layer_list.Select(index - 1, true);
});
layer_move_up.SetInteractive(false);

layer_move_down = new EmuButton(32, EMU_AUTO, 256, 32, "Move Layer Down", function() {
    var index = obj_emu_demo.layer_list.GetSelection();
    var t = obj_emu_demo.layers[| index];
    obj_emu_demo.layers[| index] = obj_emu_demo.layers[| index + 1];
    obj_emu_demo.layers[| index + 1] = t;
    obj_emu_demo.layer_list.ClearSelection();
    obj_emu_demo.layer_list.Select(index + 1, true);
});
layer_move_down.SetInteractive(false);

container.AddContent([
    new EmuText(32, 0, 256, 32, "Blend Mode Test Program"),
    layer_list,
    layer_add,
    layer_enabled,
    layer_name,
    layer_delete,
    layer_move_up,
    layer_move_down,
]);

array_blend_type = new EmuRadioArray(320, 0, 256, 32, "Blend Type:", BLEND_TYPE_DEFAULT, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    switch (value) {
        case 0: layer_data.blend_type = BLEND_TYPE_DEFAULT; break;
        case 1: layer_data.blend_type = BLEND_TYPE_ADVANCED; break;
    }
    obj_emu_demo.Refresh();
});
array_blend_type.AddOptions(["Basic", "Extended"]);
array_blend_type.SetColumns(1, 192);
array_blend_type.SetInteractive(false);

array_blend_mode_basic = new EmuRadioArray(320, EMU_AUTO, 256, 32, "Basic Types:", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.blend_single = obj_emu_demo.lookup_index_to_basic[$ value];
});
array_blend_mode_basic.AddOptions(["bm_normal", "bm_add", "bm_subtract", "bm_max"]);
array_blend_mode_basic.SetColumns(2, 192);
array_blend_mode_basic.SetInteractive(false);

array_blend_mode_ext_src = new EmuRadioArray(320, EMU_AUTO, 256, 32, "Extended Types (Source):", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.blend_src = obj_emu_demo.lookup_index_to_ext[$ value];
});
array_blend_mode_ext_src.AddOptions(["bm_zero", "bm_one", "bm_src_color", "bm_inv_src_color", "bm_src_alpha", "bm_inv_src_alpha", "bm_dest_alpha", "bm_inv_dest_alpha", "bm_dest_color", "bm_inv_dest_color", "bm_src_alpha_sat"]);
array_blend_mode_ext_src.SetColumns(6, 192);
array_blend_mode_ext_src.SetInteractive(false);

array_blend_mode_ext_dest = new EmuRadioArray(320, EMU_AUTO, 256, 32, "Extended Types (Destination):", 0, function() {
    var layer_data = obj_emu_demo.GetActiveLayer();
    layer_data.blend_dest = obj_emu_demo.lookup_index_to_ext[$ value];
});
array_blend_mode_ext_dest.AddOptions(["bm_zero", "bm_one", "bm_src_color", "bm_inv_src_color", "bm_src_alpha", "bm_inv_src_alpha", "bm_dest_alpha", "bm_inv_dest_alpha", "bm_dest_color", "bm_inv_dest_color", "bm_src_alpha_sat"]);
array_blend_mode_ext_dest.SetColumns(6, 192);
array_blend_mode_ext_dest.SetInteractive(false);

container.AddContent([
    array_blend_type,
    array_blend_mode_basic,
    array_blend_mode_ext_src,
    array_blend_mode_ext_dest,
]);

load_image_button = new EmuButtonImage(736, EMU_AUTO, 128, 128, -1, 0, c_white, 1, true, function() {
    var sprite_fn = get_open_filename("Image files|*.png;*.bmp;*jpg;*.jpeg;*", "Select an image");
    obj_emu_demo.GetActiveLayer().SetSprite(sprite_add(sprite_fn, 0, false, false, 0, 0));
    obj_emu_demo.Refresh();
});
load_image_button.alt_text = "Click to load";
load_image_button.SetInteractive(false);

render_surface = new EmuRenderSurface(736, 0, 540, 540, function(mx, my) {
    if (obj_emu_demo.preview_export_opaque) {
        draw_clear(obj_emu_demo.preview_background_color);
    } else {
        drawCheckerbox(0, 0, width, height, 1, 1, c_white, 1);
    }
    for (var i = ds_list_size(obj_emu_demo.layers) - 1; i >= 0; i--) {
        obj_emu_demo.layers[| i].Render(mx, my);
    }
    gpu_set_blendmode(bm_normal);
}, function(mx, my) { }, function() { }, function() { });

container.AddContent([
    render_surface,
    load_image_button,
]);

var button_export = new EmuButton(732 + 128 + 32, EMU_AUTO, 256, 32, "Export Image", function() {
});

var button_credits = new EmuButton(732 + 128 + 32, EMU_AUTO, 256, 32, "Credits", function() {
    
});

container.AddContent([
    new EmuColorPicker(732 + 128 + 32, load_image_button.y, 384, 32, "Background color:", preview_background_color, function() {
        obj_emu_demo.preview_background_color = value;
    }),
    button_export,
]);

container.AddContent([
    new EmuCheckbox(732 + 128 + 256 + 32, button_export.y, 128, 32, "Opaque?", preview_export_opaque, function() {
        obj_emu_demo.preview_export_opaque = value;
    }),
    new EmuCheckbox(732 + 128 + 256 + 32, button_credits.y, 128, 32, "Borders?", preview_borders, function() {
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

#region overview and credits
/*container.AddContent([
    new EmuButton(704, 32, 256, 32, "Show Character Summary", function() {
        var dialog = new EmuDialog(640, 384, "Character Summary");
        var demo = obj_emu_demo;
        var pronouns_possessive = ["Their", "His", "Her"];
        var pronoun_possessive = pronouns_possessive[demo.data.pronouns];
        var pronouns_subject = ["They", "He", "She"];
        var pronoun_subject = pronouns_subject[demo.data.pronouns];
        var pronouns_verb = ["are", "is", "is"];
        var pronoun_verb = pronouns_verb[demo.data.pronouns];
        var skill_count = ds_list_size(demo.data.skills);
        var calc_stat = function(base) {
            return 2 * base + 10;
        }
        
        var str_fav_color = emu_string_hex(colour_get_red(demo.data.favorite_color), 2) + emu_string_hex(colour_get_green(demo.data.favorite_color), 2) +
            emu_string_hex(colour_get_blue(demo.data.favorite_color), 2);
        
        var str_summary = "[rainbow][wave]" + demo.data.name + "[/wave][/rainbow] (or [rainbow][wave]" + demo.data.nickname + ",[/wave][/rainbow] according to " +
            string_lower(pronoun_possessive) + " friends) is a " + demo.all_alignments[| demo.data.alignment] + " duckling from " + demo.all_hometowns[| demo.data.hometown] + ". " +
            pronoun_subject + " " + pronoun_verb + " Level " + string(demo.data.level) + " with [c_red]" + string(calc_stat(demo.data.str)) + "[/c] Strength, [c_red]" +
            string(calc_stat(demo.data.dex)) + "[/c] Dexterity, [c_red]" + string(calc_stat(demo.data.con)) + "[/c] Constitution, [c_red]" + string(calc_stat(demo.data.int)) +
            "[/c] Intelligence, [c_red]" + string(calc_stat(demo.data.wis)) + "[/c] Wisdom, and [c_red]" + string(calc_stat(demo.data.cha)) + "[/c] Charisma. " + pronoun_subject +
            " know" + ((demo.data.pronouns != 0) ? "s" : "") + " [c_blue]" + string(skill_count) + "[/c] skill" + ((skill_count == 1) ? "" : "s") + ". " + pronoun_possessive +
            " favorite color is [#" + str_fav_color + "]0x" + str_fav_color + "[/c]";
        if (skill_count > 0) {
            if (skill_count > 3) {
                str_summary += ", including ";
            } else {
                str_summary += ": ";
            }
            switch (skill_count) {
                case 1: str_summary += demo.data.skills[| 0]; break;
                case 2: str_summary += demo.data.skills[| 0] + " and " + demo.data.skills[| 1]; break;
                default: str_summary += demo.data.skills[| 0] + ", " + demo.data.skills[| 1] + " and " + demo.data.skills[| 2]; break;
            }
        }
        str_summary += ".\n\n[#006600]" + demo.data.summary + "[/rainbow]";
        
        dialog.AddContent([
            new EmuText(32, EMU_AUTO, 560, 320, str_summary),
            new EmuButton(dialog.width / 2 - 128 / 2, dialog.height - 32 - 32 / 2, 128, 32, "Close", emu_dialog_close_auto),
        ]);
    }),
    new EmuButton(704, EMU_AUTO, 256, 32, "Credits", function() {
        var dialog = new EmuDialog(640, 320, "Credits");
        dialog.AddContent([
            new EmuText(dialog.width / 2, EMU_AUTO, 560, 64, "[c_blue][fa_center]Emu UI, a user interface framework for GameMaker Studio 2.3 written by @dragonitespam[/c]"),
            new EmuText(32, EMU_AUTO, 560, 32, "The [rainbow][wave]Scribble[/wave][/rainbow]  text renderer is by @jujuadams"),
            new EmuText(32, EMU_AUTO, 560, 32, "Models are from Kenney's Nature Kit (www.kenney.nl)"),
            new EmuText(32, EMU_AUTO, 560, 32, "Emu iconography by @gart_gh"),
            new EmuText(32, EMU_AUTO, 560, 32, "Duckling sprite by @AleMunin"),
            new EmuButton(dialog.width / 2 - 128 / 2, dialog.height - 32 - 32 / 2, 128, 32, "Close", emu_dialog_close_auto),
        ]);
    }),
]);
*/
#endregion