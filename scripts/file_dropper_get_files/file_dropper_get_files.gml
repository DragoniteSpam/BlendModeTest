function file_dropper_get_files() {
    static dll_ref_count = external_define(FILE_DROPPER_DLL, "file_drop_count", FILE_DROPPER_DLL_CALLTYPE, ty_real, 0);
	static dll_ref_get = external_define(FILE_DROPPER_DLL, "file_drop_get", FILE_DROPPER_DLL_CALLTYPE, ty_string, 1, ty_real);
	static dll_ref_flush = external_define(FILE_DROPPER_DLL, "file_drop_flush", FILE_DROPPER_DLL_CALLTYPE, ty_real, 0);
    
	var n = external_call(dll_ref_count);
	var array = array_create(n);
    
	for (var i = 0; i < n; i++) {
	    array[i] = external_call(dll_ref_get, i);
	}
    
    array_sort(array, true);
    external_call(dll_ref_flush);
    
	return array;
}