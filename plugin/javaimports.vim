fun Paste_imported_classes(file_content)
	let libdir = "/lib/"
	let libname = "libvim_javaimports.so"
	let function_name = "getImportedClasses"
	let imports = libcall(libdir . libname, function_name, a:file_content)
	:0put! =imports
endf

map <c-i> <esc>ggyGgg:call Paste_imported_classes(getreg())<cr>
