CFLAGS = -fPIC -c -Wall
CC = gcc
LDFLAGS += -shared -Wl
LIB_INSTALL_DIR = /lib
VIM_PLUGIN_DIR = /usr/share/vim/vim64/plugin

build:
	$(MAKE) libvim_javaimports.so

libvim_javaimports.so: libvim_javaimports.o
	$(CC) $(LDFLAGS) $< -o libvim_javaimports.so

install: 
	$(MAKE) libvim_javaimports.so
	cp javaimports.vim $(VIM_PLUGIN_DIR)
	cp libvim_javaimports.so $(LIB_INSTALL_DIR)

uninstall:
	rm -f $(VIM_PLUGIN_DIR)/javaimports.vim 
	rm -f $(LIB_INSTALL_DIR)/libvim_javaimports.so
clean:
	rm -f *.so *.o 
