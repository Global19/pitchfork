include ../../../mk/pitchfork.mk

# Local variables
_NAME   = Cython-0.23.3
_URL    = https://pypi.python.org/packages/source/C/Cython
_WRKSRC = $(WORKDIR)/$(_NAME)
LDFLAGS = -L$(PREFIX)/lib
export LDFLAGS

# Local works
ifeq ($(origin HAVE_CYTHON),undefined)
do-extract: $(_WRKSRC)
$(_WRKSRC): | do-fetch
	tar zxf $(_NAME).tar.gz -C $(WORKDIR)
do-fetch: | $(_NAME).tar.gz
$(_NAME).tar.gz:
	$(PFHOME)/bin/pitchfork fetch --url $(_URL)/$@
do-install: $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME): | do-extract
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)
	$(PIP) install --root $(STAGING)/$(_NAME) --no-deps $(_WRKSRC)/
	rsync -aKx $(STAGING)/$(_NAME)/$(PREFIX)/ $(PREFIX)/
	cd $(STAGING)/$(_NAME)$(PREFIX) && find * ! -type d|grep -v '^$$'|sort -r > $@
else
do-install: | $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	rm -rf $(STAGING)/$(_NAME)
	mkdir -p $(STAGING)/$(_NAME)/lib/python2.7/site-packages
	mkdir -p $(STAGING)/$(_NAME)/bin
	rsync -aKx \
            $(HAVE_CYTHON)/lib/python2.7/site-packages/cython* \
            $(HAVE_CYTHON)/lib/python2.7/site-packages/Cython* \
            $(HAVE_CYTHON)/lib/python2.7/site-packages/pyximport* \
            $(STAGING)/$(_NAME)/lib/python2.7/site-packages/
	rsync -aKx \
            $(HAVE_CYTHON)/bin/cython* \
            $(HAVE_CYTHON)/bin/cygdb \
            $(STAGING)/$(_NAME)/bin/
	rsync -aKx $(STAGING)/$(_NAME)/ $(PREFIX)/
	cd $(STAGING)/$(_NAME) && find * ! -type d|grep -v '^$$'|sort -r > $@
endif
do-clean: do-flush
do-distclean: do-flush
do-flush:
	rm -rf $(STAGING)/$(_NAME)
	rm -rf $(_WRKSRC)
