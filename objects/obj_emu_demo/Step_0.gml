var files = file_dropper_get_files();

if (array_length(files) > 0) {
    var active_layer = GetActiveLayer();
    if (active_layer) {
        for (var i = 0, n = array_length(files); i < n; i++) {
            switch (string_lower(filename_ext(files[i]))) {
                case ".png": case ".jpg": case ".jpeg": case ".jpe": case ".bmp":
                    var sprite = sprite_add(files[i], 0, false, false, 0, 0);
                    if (sprite_exists(sprite)) {
                        active_layer.SetSprite(sprite);
                    }
                    exit;
            }
        }
    }
}