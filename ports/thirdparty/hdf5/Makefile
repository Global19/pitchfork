include ../../../mk/pitchfork.mk

# CXX check
include ../../../mk/chkcxx.mk

# Local variables
_NAME   = hdf5-1.8.19
_URL    = https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.19/src
_FILE   = $(_NAME).tar.gz
_WRKSRC = $(WORKDIR)/$(_NAME)
ifneq ($(OPSYS),Darwin)
LDFLAGS += -Wl,-rpath,'\$$\$$ORIGIN/../lib'
export LDFLAGS
endif

# Local works
ifeq ($(origin HAVE_HDF5),undefined)
do-fetch: $(_FILE)
$(_FILE):
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_FILE) -C $(WORKDIR)
do-config: $(_WRKSRC)/config.log
$(_WRKSRC)/config.log: | do-extract
	(cd $(_WRKSRC) && \
          CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" ./configure --prefix=$(STAGING)/$(_NAME) --enable-cxx \
                    --with-shared --with-zlib=$(ZLIB_ROOT)) >& config.log || $(PFHOME)/bin/diewith config.log
do-build: $(_WRKSRC)/src/.libs/libhdf5.$(DYLIB)
$(_WRKSRC)/src/.libs/libhdf5.$(DYLIB): | do-config
	$(MAKE) -C $(_WRKSRC) >& build.log || $(PFHOME)/bin/diewith build.log
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-build
	rm -rf $(STAGING)/$(_NAME)
	$(MAKE) -C $(_WRKSRC) install >& install.log || $(PFHOME)/bin/diewith install.log
	mkdir -p $(STAGING)/$(_NAME)/lib/pkgconfig
	$(SED) -e "s@^prefix=.*@prefix=$(PREFIX)@" hdf5.pc > $(STAGING)/$(_NAME)/lib/pkgconfig/hdf5.pc
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $@
else
_HDF5 = $(shell ../../../bin/checkHDF5 $(HAVE_HDF5))
_NAME = hdf5
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/include
	mkdir -p $(STAGING)/$(_NAME)/lib
	mkdir -p $(STAGING)/$(_NAME)/bin
	cp -aL $(_HDF5)/bin/h5ls     $(STAGING)/$(_NAME)/bin/
	cp -aL $(_HDF5)/bin/h5dump   $(STAGING)/$(_NAME)/bin/
	cp -aL $(_HDF5)/bin/h5repack $(STAGING)/$(_NAME)/bin/
	cp -aL $(_HDF5)/include/H5*.h $(_HDF5)/include/hdf5*.h $(STAGING)/$(_NAME)/include/
	find $(_HDF5)/lib \( -name 'libhdf5*' -o -name 'libsz.*' \) -exec cp -aL {} $(STAGING)/$(_NAME)/lib/ \;
	mkdir -p $(STAGING)/$(_NAME)/lib/pkgconfig
	$(SED) -e "s@^prefix=.*@prefix=$(PREFIX)@" hdf5.pc > $(STAGING)/$(_NAME)/lib/pkgconfig/hdf5.pc
	cd $(STAGING)/$(_NAME) && tar cf - * | tar xf - -C $(PREFIX)
	find $(STAGING)/$(_NAME) ! -type d|awk -F '$(STAGING)/$(_NAME)/' '{print $$2}' > $(PREFIX)/var/pkg/$(_NAME)
endif
do-clean: do-flush
do-distclean: do-flush
do-flush:
	rm -rf $(_WRKSRC)
	rm -f build.log install.log config.log
