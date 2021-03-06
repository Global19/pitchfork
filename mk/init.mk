# This file must not include bootstrap.mk,
# else inifinite loop.
override SELF_DIR:=$(dir $(lastword $(MAKEFILE_LIST)))
override PFHOME:=$(CURDIR)
-include $(SELF_DIR)/../settings.mk
include $(SELF_DIR)/config.mk

init: sanity
	mkdir -p "$(WORKDIR)"
	mkdir -p "$(DISTFILES)"
	mkdir -p "$(STAGING)"
	mkdir -p "$(PREFIX)/bin"
	mkdir -p "$(PREFIX)/etc"
	mkdir -p "$(PREFIX)/include"
	mkdir -p "$(PREFIX)/lib"
	mkdir -p "$(PREFIX)/lib/pkgconfig"
	mkdir -p "$(PREFIX)/share"
	mkdir -p "$(PREFIX)/var/pkg"
ifeq ($(OPSYS),Darwin)
	echo "export DYLD_LIBRARY_PATH=$(PREFIX)/lib:\$$DYLD_LIBRARY_PATH"|sed -e 's/::*/:/g' > "$(PREFIX)/setup-env.sh"
else
	echo "export   LD_LIBRARY_PATH=$(PREFIX)/lib:\$$LD_LIBRARY_PATH"  |sed -e 's/::*/:/g' > "$(PREFIX)/setup-env.sh"
endif
	echo "export PATH=$(PREFIX)/bin:\$$PATH"|sed -e 's/::*/:/g' >> "$(PREFIX)/setup-env.sh"
	echo "OLDPS1=\$$PS1" >> "$(PREFIX)/setup-env.sh"
	echo "[[ \"\$$PS1\" ]] && PS1=\"pitchfork($$($(PFHOME)/bin/pitchfork short-branch)) \$$PS1\" || PS1=\($$($(PFHOME)/bin/pitchfork short-branch)\)" >> "$(PREFIX)/setup-env.sh"


ifeq ($(OPSYS),Darwin)
_tmpvar:=$(if $(shell which $(MD5SUM)),exists,$(error "unable to run md5sum, consider doing brew install md5sha1sum"))
#else ifeq ($(OPSYS),FreeBSD)
#_tmpvar:=$(if $(shell which $(MD5SUM)),exists,$(error "unable to run md5sum, consider doing pkg install coreutils"))
else
_tmpvar:=$(if $(shell which $(MD5SUM)),exists,$(error "unable to run md5sum, consider doing yum install coreutils"))
endif

sanity:
	$(PFHOME)/bin/checkSystem
	$(PFHOME)/bin/checkCC $(CC)

# utils
_startover::
	bin/pitchfork startover

.PHONY: init sanity
