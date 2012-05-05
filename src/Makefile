# GNU Makefile for Smart Cache/src
#
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License version 2

#JAVAC_FLAGS=-O

GCJ_FLAGS=-Wall -fno-store-check -O2 -fforce-classes-archive-check --classpath /usr/share/java:. --main=scache
GCJ_DEBUG=-v -save-temps
GCJ=gcj-4.2

JAVAC=javac

JAR=scache.jar

sources=cacheobject.java mgr.java request.java \
	HTUU.java garbage.java regexp.java scache.java \
	cachedir.java httpreq.java repair.java InOut.java ui.java \
	uireq.java WebConnection.java ConnectionHandler.java \
	shutdownhook.java
	
classes=cacheobject.class mgr.class request.class \
	HTUU.class garbage.class regexp.class scache.class \
	cachedir.class httpreq.class repair.class InOut.class ui.class \
	uireq.class WebConnection.class ConnectionHandler.class \
	shutdownhook.class

JCLSS		= $(JSRC:.java=.class)

.java.class:
	$(JAVAC) $(JAVAC_FLAGS) $<
	
default: scache tags $(JCLSS)

debug:  JAVAC_FLAGS=-g
debug:  scache tags

opt:  JAVAC_FLAGS=-O
opt:  scache tags

normal:  JAVAC_FLAGS=
normal:  scache tags

all:	scache scache-native tags $(JAR)

scache: $(sources)
	-@echo "Compiling Smart Cache..."
	$(JAVAC) $(JAVAC_FLAGS) $?
	-touch scache

native: scache-native

scache-native: $(sources)
	$(GCJ) $(GCJ_FLAGS) $(sources) -o scache-native
	
jar:	$(JAR)

$(JAR): scache
	jar cfm $(JAR) MANIFEST.MF $(classes) $(JCLSS)

tags:	$(sources)
	-ctags $(sources)
run:	scache
	java -ms1m scache
clean:
	rm -f *.class tags scache
	rm -rf store
	rm -f *.jar *.zip
	rm -f scache-native
	rm -f *.i *.o *.s

install: scache jar
ifndef datadir
	-@echo "Run top-level makefile instead.."
else
	install -d $(datadir)/java
	install $(JAR) $(datadir)/java
endif

install-native: scache-native
	install scache-native $(bindir)

zip:	scache
	cp *.class $(DESTDIR)
	#install -d $(DESTDIR)/src
	install -d $(DESTDIR)/META-INF
	cp -p MANIFEST.MF $(DESTDIR)/META-INF
	#cp *.java MANIFEST.MF $(DESTDIR)/src
	#-flip -m $(DESTDIR)/src/*

tar:
	#install -d $(DESTDIR)/src
	#cp $(sources) MANIFEST.MF $(DESTDIR)/src
	#cp Makefile $(DESTDIR)/src
	#No .classes in tar
	#cp $(classes) $(DESTDIR)

.PHONY: run debug clean	default install zip tar jar install-native native
.SUFFIXES:      .class .java
