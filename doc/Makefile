#Makefile for Smart Cache/doc

docfiles=copyright README scachenow.jpg TODO netware.html
manfiles=scache.8
czhtml=czech.html bfu.html README.CZ Win_install.html announce.html
htmlfiles=smartcache.sasp* smartcache.html

default all native: html
	
man: $(manfiles)
html:   ../html/

../html/:  smartcache.sgml
	   #rm -rf ../html/
	   install -d ../html/
	   -debiandoc2html smartcache.sgml
	   -mv smartcache.html/* ../html/
	   -rmdir smartcache.html
	   touch ../html/mark
	   rm ../html/mark

clean:
	rm -rf $(htmlfiles) ../html/
	rm -f *.bak

debug:

view:   html
	-w3m ../html/index.html

tar:
	#install -d $(DESTDIR)/doc
	#install -d $(DESTDIR)/html
	#cp $(docfiles) $(czhtml) $(DESTDIR)/doc
	#cp scache.8 smartcache-manual smartcache.sgml $(DESTDIR)/doc
	#cp Makefile $(DESTDIR)/doc
	#cp ../html/* $(DESTDIR)/html

zip: html
	install -d $(DESTDIR)/html
	cp -p ../html/*.html $(DESTDIR)/html
	-flip -mb $(DESTDIR)/html/*.html
	cp -p $(docfiles) $(DESTDIR)
	-cd $(DESTDIR) && flip -m $(docfiles)
	install -d $(DESTDIR)/czech
	cp -p $(czhtml) $(DESTDIR)/czech
	-cd $(DESTDIR)/czech && flip -mb $(czhtml)
	

install: PKG=scache
install: install-common

install-native: PKG=scache-native
install-native: install-common

install-common: man html
ifndef prefix
	-echo "Use top level makefile"
else
	mkdir -p $(prefix)/share/doc/$(PKG)/html
	#-ln -sn ../copyright/GPL $(prefix)/doc/scache/COPYING.GPL
	#install -m 664 -o root -g root scache.8 $(mandir)/man8
	#gzip --best $(mandir)/man8/scache.8
	install -m 644 -o root -g root ../html/* $(prefix)/share/doc/$(PKG)/html
	install -m 644 $(docfiles) $(prefix)/share/doc/$(PKG)
	#-install -m 644 -o root -g root smartcache-manual $(datadir)/doc-base
endif
.PHONY: default install clean debug all man tar
