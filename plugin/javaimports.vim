fun Get_user_input(bufcontent_i, bufcontent_j, counter_i, counter_j)
	let prompt_u = "There are ambigous imports!\n"
	let prompt_u = prompt_u . "[" . a:counter_i . "] " . a:bufcontent_i . "\n"
	let prompt_u = prompt_u . "[" . a:counter_j . "] " . a:bufcontent_j . "\n"
	let prompt_u = prompt_u . "Your choice: "
	return input(prompt_u)
endf

fun Del_ambigous_imports(buffer)
	let counter_i = 0
	let bufcontent_i = getbufvar(a:buffer, counter_i)
	while bufcontent_i != -1
		let counter_j = counter_i + 1
		let bufcontent_j = getbufvar(a:buffer, counter_j)
		while bufcontent_j != -1
			if strpart(bufcontent_i, strridx(bufcontent_i, ".")) == strpart(bufcontent_j, strridx(bufcontent_j, "."))
				let in_u = Get_user_input(bufcontent_i, bufcontent_j, counter_i, counter_j)
				while in_u != counter_i && in_u != counter_j
					let in_u = Get_user_input(bufcontent_i, bufcontent_j, counter_i, counter_j)
					echo in_u
				endw
				if in_u != counter_i 
					:call setbufvar(a:buffer, counter_i, 0)
				elseif in_u != counter_j
					:call setbufvar(a:buffer, counter_j, 0)
				endif
			endif
			let counter_j = counter_j + 1
			let bufcontent_j = getbufvar(a:buffer, counter_j)
		endw
		let counter_i = counter_i + 1
		let bufcontent_i = getbufvar(a:buffer, counter_i)
	endw
endf

fun Get_paste_content(buffer)
	let counter = 0
	let paste_content = ""
	let bufcontent  = getbufvar(a:buffer, counter)
	while bufcontent != -1
		if bufcontent !=# "0"
			let paste_content = paste_content . bufcontent . "\n"
		endif
		let counter = counter + 1
		let bufcontent = getbufvar(a:buffer, counter)
	endw
	return paste_content
endf

fun Fill_buffer(imports, buffer)
	let counter = 0
	let imports = a:imports
	let end_pos = stridx(imports, "\n")
	while end_pos > 0
		let claus = strpart(imports, 0, end_pos)
		:call setbufvar(a:buffer, counter, claus)
		let imports = strpart(imports, end_pos + 1)
		let counter = counter + 1
		let end_pos = stridx(imports, "\n")
	endw
	:call setbufvar(a:buffer, counter, -1)
endf

fun Paste_imported_classes(file_content)
	let libdir = "/usr/lib/"
	let libname = "libvim_javaimports.so"
	let function_name = "getImportedClasses"
	let imports = libcall(libdir . libname, function_name, a:file_content)
	if imports !=# ""
		:call Fill_buffer(imports, "r")
		:call Del_ambigous_imports("r")
		let paste_content = Get_paste_content("r")
		:0put! =paste_content
	endif
endf

if expand('%:e') ==# "java"
	map `ii <esc>ggyGgg:call Paste_imported_classes(getreg())<cr>
	imap `ii <esc>ggyGgg:call Paste_imported_classes(getreg())<cr>i
endif
