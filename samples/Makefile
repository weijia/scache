#Makefile for Smart Cache / samples

CFGFILES=cookies.cnf fail.cnf gc.cnf pass.cnf scache.cnf rfail.cnf redir.cnf rewrite.cnf

default clean debug native:

install install-native: $(CFGFILES)
ifndef sysconfdir
	-@echo "Run top level makefile instead."
else
ifndef DESTDIR
	install -m 755 -o root -g root -d $(sysconfdir)/scache
	install -m 644 -o root -g root $(CFGFILES) $(sysconfdir)/scache
	install -m 755 -o proxy -g proxy -d $(localstatedir)/cache/scache
endif	
endif	

tar:
	install -d $(DESTDIR)/samples
	cp * $(DESTDIR)/samples

zip: $(CFGFILES)
	install -d $(DESTDIR)/samples
	cp -p $(CFGFILES) $(DESTDIR)/samples
	sed -e 's/^cache_dir.*$$/cache_dir C:\\store/g' -e's/^Shutdown_flag.*$$/Shutdown_flag C:\\stop/g' -e 's/^immediate_shutdown_flag.*$$/Immediate_shutdown_flag C:\\stop.now/g' -e 's/^alive_flag.*$$/alive_flag C:\\scache.running/g' scache.cnf > $(DESTDIR)/samples/scache.cnf
	-flip -m $(DESTDIR)/samples/*

.PHONY: debug default clean install zip all tar
