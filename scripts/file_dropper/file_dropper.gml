#macro FILE_DROPPER_DLL "FileDropper.dll"
#macro FILE_DROPPER_DLL_CALLTYPE dll_cdecl
#macro FILE_DROPPER_VERSION "1.1.0"

global.__use_file_dropper = true;

try {
    var dll_ref = external_define(FILE_DROPPER_DLL, "init", FILE_DROPPER_DLL_CALLTYPE, ty_real, 1, ty_string);
    external_call(dll_ref, window_handle());
    external_free(dll_ref);
    file_dropper_version();
} catch (e) {
    global.__use_file_dropper = false;
    show_debug_message("Unable to load the File Dropper: " + e.message);
}