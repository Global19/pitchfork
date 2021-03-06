include ../../../mk/pitchfork.mk

# Local variables
_NAME   = ncurses-6.0
_URL    = ftp://ftp.gnu.org/gnu/ncurses
_FILE   = $(_NAME).tar.gz
_WRKSRC = $(WORKDIR)/$(_NAME)
ifneq ($(OPSYS),Darwin)
LDFLAGS += -Wl,-rpath,'\$$\$$ORIGIN/../lib'
export LDFLAGS
endif

# Local works
ifeq ($(origin HAVE_NCURSES),undefined)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-clean-distfile:
	rm -f $(_FILE)
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" CPP="gcc -E -P" ./configure --prefix=$(PREFIX) --with-shared --without-ada 2>&1) \
        >& config.log || $(PFHOME)/bin/diewith config.log
	sleep 1
do-build: $(_WRKSRC)/lib/libncurses.$(DYLIB)
$(_WRKSRC)/lib/libncurses.$(DYLIB): | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(SED) -i -e 's@^#! /bin/sh@#!/bin/sh@' $(_WRKSRC)/headers.sh
	$(MAKE) -C $(_WRKSRC) \
            prefix=$(STAGING)/$(_NAME) \
            ticdir=$(STAGING)/$(_NAME)/share/terminfo \
            install >& install.log || $(PFHOME)/bin/diewith install.log
	mkdir -p $(STAGING)/$(_NAME)/lib/pkgconfig
	$(SED) -e "s@^prefix=.*@prefix=$(PREFIX)@" ncurses.pc > $(STAGING)/$(_NAME)/lib/pkgconfig/ncurses.pc
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	ln -sfn libncurses.$(DYLIB) $(PREFIX)/lib/libcurses.$(DYLIB)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
	echo lib/libcurses.$(DYLIB) >> $@
else
_NCURSES := $(shell ../../../bin/checkNCURSES $(HAVE_NCURSES))
_NAME     = ncurses
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/include
	mkdir -p $(STAGING)/$(_NAME)/lib/pkgconfig
	mkdir -p $(STAGING)/$(_NAME)/share
	cp -aL $(_NCURSES)/include/ncurses $(STAGING)/$(_NAME)/include/
	find $(_NCURSES)/lib -maxdepth 1 \
             \( -name 'libcurse*$(DYLIB)*'  \
             -o -name 'libform*$(DYLIB)*'   \
             -o -name 'libmenu*$(DYLIB)*'   \
             -o -name 'libncurse*$(DYLIB)*' \
             -o -name 'libpanel*$(DYLIB)*'  \
             -o -name 'terminfo'            \
             \) -exec cp -aL {} $(STAGING)/$(_NAME)/lib/ \;
	cp -aL $(_NCURSES)/share/terminfo $(STAGING)/$(_NAME)/share/
	$(SED) -e "s@^prefix=.*@prefix=$(PREFIX)@" ncurses.pc > $(STAGING)/$(_NAME)/lib/pkgconfig/ncurses.pc
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
endif
do-clean: do-flush
do-distclean: do-flush
do-flush:
	rm -rf $(_WRKSRC)
	rm -f build.log install.log config.log
