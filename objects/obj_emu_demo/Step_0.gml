var files = file_dropper_get_files([".png", ".jpg", ".jpeg", ".jpe", ".bmp"]);
file_dropper_flush();

if (array_length(files) > 0) {
	for (var i = 0, n = array_length(files); i < n; i++) {
	    var sprite = sprite_add(files[i], 0, false, false, 0, 0);
	    if (sprite_exists(sprite)) {
			var layer_number = array_length(self.layers);
			var new_layer = new LayerData(filename_name(files[i]));
			var selection = obj_emu_demo.layer_list.GetSelection();
			if (selection != -1) {
				array_insert(self.layers, selection, new_layer);
			} else {
				array_push(obj_emu_demo.layers, new_layer);
			}
			
			new_layer.SetSprite(sprite);
			if (layer_number == 0) {
			    self.layer_list.Select(0, true);
			} else {
			    self.Refresh();
			}
	    }
	}
}