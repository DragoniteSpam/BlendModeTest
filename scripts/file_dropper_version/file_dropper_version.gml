function file_dropper_version() {
    static dll_ref = external_define(FILE_DROPPER_DLL, "file_dropper_version", FILE_DROPPER_DLL_CALLTYPE, ty_string, 0);
    show_debug_message("File dropper GML version: " + FILE_DROPPER_VERSION);
    show_debug_message("File dropper DLL version: " + external_call(dll_ref));
}

file_dropper_version();