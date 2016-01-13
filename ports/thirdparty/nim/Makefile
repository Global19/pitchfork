include ../../../mk/config.mk

# Local variables
_NAME            = nim-0.12.0
_URL             = http://nim-lang.org/download
_WRKSRC          = $(WORKSPACE)/$(_NAME)

# Local works
do-fetch: wscheck
	@test -e $(_NAME).zip || curl -O -L $(_URL)/$(_NAME).zip
	@which $(MD5SUM) >& /dev/null && $(MD5SUM) -c MD5SUM
do-extract: do-fetch
	@test -d $(_WRKSRC) || unzip $(_NAME).zip -d $(WORKSPACE)
do-config: do-extract
do-build: do-config $(_WRKSRC)/bin/nim
$(_WRKSRC)/bin/nim:
	@cd $(_WRKSRC) && sh build.sh
do-install: do-build pfcheck $(PREFIX)/var/pkg/$(_NAME)
$(PREFIX)/var/pkg/$(_NAME):
	@mkdir -p $(STAGING)/$(_NAME)
	@mkdir -p $(PREFIX)/share/doc
	@cd $(_WRKSRC) && sh install.sh $(STAGING)/$(_NAME)
	@find $(PREFIX) ! -type d > $(_WRKSRC).before.list
	@find $(PREFIX) -type d > $(_WRKSRC).before.dlist
	@cp -a $(STAGING)/$(_NAME)/nim/bin/nim  $(PREFIX)/bin/
	@cp -a $(STAGING)/$(_NAME)/nim/lib      $(PREFIX)/lib/nim
	@cp -a $(STAGING)/$(_NAME)/nim/doc      $(PREFIX)/share/doc/nim
	@cp -a $(STAGING)/$(_NAME)/nim/config/* $(PREFIX)/etc/
	@find $(PREFIX) ! -type d > $(_WRKSRC).after.list
	@find $(PREFIX) -type d > $(_WRKSRC).after.dlist
	@diff -u $(_WRKSRC).before.list $(_WRKSRC).after.list | \
	grep -v '^\++'|awk -F $(PREFIX)/ '/^\+/{print $$2}' >  $(PREFIX)/var/pkg/$(_NAME)
	@diff -u $(_WRKSRC).before.dlist $(_WRKSRC).after.dlist | \
	grep -v '^\++'|awk -F $(PREFIX)/ '/^\+/{print $$2}' >> $(PREFIX)/var/pkg/$(_NAME)
do-uninstall:
	@cd $(PREFIX) && cat var/pkg/$(_NAME) | xargs rm -rf
	@rm -rf $(PREFIX)/var/pkg/$(_NAME)