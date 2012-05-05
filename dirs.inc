#directory handling stuff ala ./configure
#modified for Debian DESTDIR
#Version 1.0
#PUBLIC DOMAIN

ifndef prefix
prefix:=$(DESTDIR)/usr/local
else
prefix:=$(DESTDIR)$(prefix)
endif
export prefix

ifndef exec-prefix
exec-prefix:=$(prefix)
else
exec-prefix:=$(DESTDIR)$(exec-prefix)
endif
export exec-prefix

ifndef bindir
bindir:=$(exec-prefix)/bin
else
bindir:=$(DESTDIR)$(bindir)
endif
export bindir

ifndef sbindir
sbindir:=$(exec-prefix)/sbin
else
sbindir:=$(DESTDIR)$(sbindir)
endif
export sbindir

ifndef libexecdir
libexecdir:=$(exec-prefix)/libexec
else
libexecdir:=$(DESTDIR)$(libexecdir)
endif
export libexecdir

ifndef datadir
datadir:=$(prefix)/share
else
datadir:=$(DESTDIR)$(datadir)
endif
export datadir

ifndef sysconfdir
sysconfdir:=$(prefix)/etc
else
sysconfdir:=$(DESTDIR)$(sysconfdir)
endif
export sysconfdir

ifndef sharedstatedir
sharedstatedir:=$(prefix)/com
else
sharedstatedir:=$(DESTDIR)$(sharedstatedir)
endif
export sharedstatedir

ifndef localstatedir
localstatedir:=$(prefix)/var
else
localstatedir:=$(DESTDIR)$(localstatedir)
endif
export localstatedir

ifndef libdir
libdir:=$(exec-prefix)/lib
else
libdir:=$(DESTDIR)$(libdir)
endif
export libdir

ifndef includedir
includedir:=$(prefix)/include
else
includedir:=$(DESTDIR)$(includedir)
endif
export includedir

ifndef oldincludedir
oldincludedir:=$(prefix)/include
else
oldincludedir:=$(DESTDIR)$(oldincludedir)
endif
export oldincludedir

ifndef infodir
infodir:=$(prefix)/info
else
infodir:=$(DESTDIR)$(infodir)
endif
export infodir

ifndef mandir
mandir:=$(prefix)/man
else
mandir:=$(DESTDIR)$(mandir)
endif
export mandir
