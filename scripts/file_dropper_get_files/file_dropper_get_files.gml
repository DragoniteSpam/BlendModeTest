function file_dropper_get_files() {
    if (!global.__use_file_dropper) return;
    static dll_ref_count = undefined;
    static dll_ref_get = undefined;
    static dll_ref_flush = undefined;
    if (!dll_ref_count) dll_ref_count = external_define(FILE_DROPPER_DLL, "file_drop_count", FILE_DROPPER_DLL_CALLTYPE, ty_real, 0);
    if (!dll_ref_get) dll_ref_get = external_define(FILE_DROPPER_DLL, "file_drop_get", FILE_DROPPER_DLL_CALLTYPE, ty_string, 1, ty_real);
    if (!dll_ref_flush) dll_ref_flush = external_define(FILE_DROPPER_DLL, "file_drop_flush", FILE_DROPPER_DLL_CALLTYPE, ty_real, 0);
    
	var n = external_call(dll_ref_count);
	var array = array_create(n);
    
	for (var i = 0; i < n; i++) {
	    array[i] = external_call(dll_ref_get, i);
	}
    
    array_sort(array, true);
    external_call(dll_ref_flush);
    
	return array;
}