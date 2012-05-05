# Top level GNU Makefile for
#       >>> Smart Cache <<<
#           full featured Java-based HTTP-proxy caching daemon
#
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License version 2

#directory set-up
prefix=/usr
sysconfdir=/etc
MAJOR=0
MINOR=94
export MAJOR
export MINOR

include dirs.inc

subdirs:
	cd src && $(MAKE) $(MAKECMDGOALS) 
	cd doc && $(MAKE) $(MAKECMDGOALS)
	cd samples && $(MAKE) $(MAKECMDGOALS)
	cd scripts && $(MAKE) $(MAKECMDGOALS)
	cd debian && $(MAKE) $(MAKECMDGOALS)

all clean debug install install-native native: subdirs

zip: DESTDIR =$(CURDIR)/debian/tmp
zip: ZIP =$(CURDIR)/../scache$(MAJOR)$(MINOR).zip

zip:
	-echo $(DESTDIR)
	-echo $(CURDIR)

	$(MAKE) MAKECMDGOALS=
	-rm -rf $(DESTDIR)
	-rm -f $(ZIP)
	install -d $(DESTDIR)
	cd src && $(MAKE) $(MAKECMDGOALS) 
	cd doc && $(MAKE) $(MAKECMDGOALS)
	cd samples && $(MAKE) $(MAKECMDGOALS)
	cd scripts && $(MAKE) $(MAKECMDGOALS)
	-echo "Building zip file: "$(ZIP)
	cd $(DESTDIR) && zip -9 -o -X -q -r $(ZIP) *
	rm -rf $(DESTDIR)
	-advzip -z -4  $(ZIP)

tar: DESTDIR =$(CURDIR)/debian/tmp/scache-$(MAJOR).$(MINOR)
tar: ZIP =$(CURDIR)/../scache-$(MAJOR).$(MINOR).tar

     export DESTDIR
tar:
	-rm -rf debian/tmp/
	-rm -rf $(DESTDIR)
	install -d debian/tmp
	bzr export --format=dir $(DESTDIR)
	cd doc && $(MAKE) $(MAKECMDGOALS)
	cd src && $(MAKE) $(MAKECMDGOALS)
	ln -snf doc/README $(DESTDIR)/README
	ln -snf doc/README.CZ $(DESTDIR)/README.CZ
	ln -snf doc/TODO $(DESTDIR)/TODO
	ln -snf doc/copyright $(DESTDIR)/COPYRIGHT
	#ln -snf html/ch-new.html $(DESTDIR)/ChangeLog.html
	-echo "Building tar.gz file: "$(ZIP)
	cd $(DESTDIR)/../ && tar cof $(ZIP) .
	gzip -f --best $(ZIP)
	-rm -rf debian/tmp/

.PHONY: default clean debug install all zip tar subdirs install-native
