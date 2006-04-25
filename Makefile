CFLAGS = -fPIC -c -Wall
CC = gcc
LDFLAGS += -shared
VIM_PLUGIN_DIR = $$HOME/.vim/plugin

build:
	$(MAKE) libvim_javaimports.so

libvim_javaimports.so: libvim_javaimports.o
	$(CC) $(LDFLAGS) $< -o libvim_javaimports.so

install: 
	$(MAKE) libvim_javaimports.so
	if ! test -d $(VIM_PLUGIN_DIR); then\
		mkdir -p $(VIM_PLUGIN_DIR);\
	fi
	cp javaimports.vim $(VIM_PLUGIN_DIR)
	cp libvim_javaimports.so $(VIM_PLUGIN_DIR)

uninstall:
	rm -f $(VIM_PLUGIN_DIR)/javaimports.vim 
	rm -f $(VIM_PLUGIN_DIR)/libvim_javaimports.so
clean:
	rm -f *.so *.o 
