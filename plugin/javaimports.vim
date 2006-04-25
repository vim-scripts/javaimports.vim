fun JavaImports_Get_user_input(ambiguous_clauses)
	let prompt_u = "There are ambiguous imports!\n"
	let prompt_u = prompt_u . a:ambiguous_clauses
	let prompt_u = prompt_u . "Your choice: "
	return input(prompt_u)
endf

fun JavaImports_Del_ambigous_imports(buffer)
	let counter_i = 0
	let bufcontent_i = getbufvar(a:buffer, counter_i)
	while bufcontent_i != -1
		let counter_j = 0
		let bufcontent_j = getbufvar(a:buffer, counter_j)
		let ambiguous_clauses = ""
		while bufcontent_j != -1
			if counter_j != counter_i
				if (strpart(bufcontent_i, strridx(bufcontent_i, ".")) == strpart(bufcontent_j, strridx(bufcontent_j, "."))) && bufcontent_i !=# "0" && bufcontent_j !=# "0"
					let ambiguous_clauses = ambiguous_clauses . "[" . counter_j . "] " . bufcontent_j . "\n"
				endif
			endif
			let counter_j = counter_j + 1
			let bufcontent_j = getbufvar(a:buffer, counter_j)
		endw
		if ambiguous_clauses !=# ""
			let ambiguous_clauses = "[" . counter_i . "] " . bufcontent_i . "\n" . ambiguous_clauses
		endif
		if bufcontent_i !=# "0" && ambiguous_clauses !=# ""
			while 1
				let user_in = JavaImports_Get_user_input(ambiguous_clauses)
				let tmp_str = ambiguous_clauses
				let end_pos = stridx(tmp_str, "[")
				let found = 0
				while end_pos >= 0
					let numbers = strpart(tmp_str, end_pos + 1, 1)
					let tmp_str = strpart(tmp_str, end_pos + 1)
					let end_pos = stridx(tmp_str, "[")
					if user_in ==# numbers
						let found = 1
						break
					endif				
				endw
				if found == 1
					let tmp_str = ambiguous_clauses
					let end_pos = stridx(tmp_str, "[")
					let found = 0
					while end_pos >= 0
						let numbers = strpart(tmp_str, end_pos + 1, 1)
						let tmp_str = strpart(tmp_str, end_pos + 1)
						let end_pos = stridx(tmp_str, "[")
						if user_in !=# numbers
							call setbufvar(a:buffer, numbers, "0")
						endif
					endw
					break
				endif
			endw
		endif
		let counter_i = counter_i + 1
		let bufcontent_i = getbufvar(a:buffer, counter_i)
	endw
endf

fun JavaImports_Get_paste_content(buffer)
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

fun JavaImports_Fill_buffer(imports, buffer)
	let counter = 0
	let imports = a:imports
	let end_pos = stridx(imports, "\n")
	while end_pos > 0
		let claus = strpart(imports, 0, end_pos)
		call setbufvar(a:buffer, counter, claus)
		let imports = strpart(imports, end_pos + 1)
		let counter = counter + 1
		let end_pos = stridx(imports, "\n")
	endw
	call setbufvar(a:buffer, counter, -1)
endf

fun JavaImports_Insert_imported_classes(file_content)
	let libdir = expand("$HOME") . "/.vim/plugin/"
	let libname = "libvim_javaimports.so"
	let function_name = "getImportedClasses"
	let imports = libcall(libdir . libname, function_name, a:file_content)
	if imports !=# ""
		call JavaImports_Fill_buffer(imports, "r")
		call JavaImports_Del_ambigous_imports("r")
		let paste_content = JavaImports_Get_paste_content("r")
		0put! =paste_content
	endif
endf

au FileType java map `ii <esc>ggyGgg:call JavaImports_Insert_imported_classes(getreg())<cr>
au FileType	java imap `ii <esc>ggyGgg:call JavaImports_Insert_imported_classes(getreg())<cr>i
