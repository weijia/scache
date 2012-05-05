#Makefile for Smart Cache/scripts

default zip all clean debug native:

zip:
	install -d $(DESTDIR)/contrib
	cp -p *.cmd *.vbs *.py $(DESTDIR)/contrib
	#install -d $(DESTDIR)/unix
	#cp -a smartcache scache.d cron.weekly cron.daily ip-up.d $(DESTDIR)/unix
	cp -p *.bat $(DESTDIR)

install-common:
	install -m 755 -o root -g root -d $(sysconfdir)/ppp/ip-up.d
	install -m 755 -o root -g root ip-up.d $(sysconfdir)/ppp/ip-up.d/scache

install: install-common
	install -m 755 -o root -g root smartcache $(bindir)
install-native: install-common
	install -m 755 -o root -g root smartcache-native $(bindir)/smartcache

tar:
	install -d $(DESTDIR)/scripts
	cp -p *       $(DESTDIR)/scripts

.PHONY: all default install clean zip tar
