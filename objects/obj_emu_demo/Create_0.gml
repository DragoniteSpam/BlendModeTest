#macro BLEND_TYPE_DEFAULT 0
#macro BLEND_TYPE_ADVANCED 1

function LayerData(sprite, blend_type, blend_src, blend_dest) constructor {
    self.sprite = sprite;
    self.blend_type = blend_type;
    self.blend_src = blend_src;
    self.blend_dest = blend_dest;
    
    self.Render = function() {
        if (self.blend_type == BLEND_TYPE_DEFAULT) {
            gpu_set_blendmode(self.blend_src);
        } else {
            gpu_set_blendmode_ext(self.blend_src, self.blend_dest);
        }
        draw_sprite(self.sprite, 0, 0, 0);
    };
};

layers = ds_list_create();

container = new EmuCore(32, 32, 640, 640);
container.AddContent([
    new EmuText(32, 32, 256, 32, "Blend Mode Test Program"),
    new EmuList(32, EMU_AUTO, 256, 32, "Layers:", 32, 8, function() {
    }),
]);

#region overview and credits
container.AddContent([
    new EmuButton(704, 32, 256, 32, "Show Character Summary", function() {
        /*var dialog = new EmuDialog(640, 384, "Character Summary");
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
        ]);*/
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
#endregion