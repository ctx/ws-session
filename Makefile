.PHONY: test deps version

VERSION:=1.0 (First Release)
LIBDIR:=$(DESTDIR)$(PREFIX)/lib/ws-session
BINDIR:=$(DESTDIR)$(PREFIX)/bin
ETCDIR:=$(DESTDIR)/etc/xdg/ws-session
ZSHDIR:=$(DESTDIR)$(PREFIX)/share/zsh/site-functions
MAN1DIR:=$(DESTDIR)$(PREFIX)/share/man/man1
MAN7DIR:=$(DESTDIR)$(PREFIX)/share/man/man7

# target:  help       - Display this help
help:
	@echo "Makefile for ws-session"
	@echo
	@echo "There is no need to compile, this are some install routines:"
	@egrep "^# target:" [Mm]akefile | cut -d":" -f2
	

# target:  test       - Run the (automatic) core tests (data,wm) 
test:
	@bash test/test-core-data.sh
	@bash test/test-core-wm.sh


# target:  version    - Show version
version:
	@echo "$(VERSION)"


# target:  deps       - Check for missing dependencies
.ONESHELL:
deps:
	@r=0
	for p in wmctrl xprop xdotool ; do
	  if ! which $$p >/dev/null; then r=1; echo $$p not found; fi
	done
	test $$r -eq 1 && echo "You need to install all dependencies to use ws-session.\n"
	exit $$r

# target:  install    - Install to $(DESTDIR)$(PREFIX)
install: deps
	install -d $(LIBDIR)/core $(LIBDIR)/app $(LIBDIR)/wm $(BINDIR) $(ETCDIR) $(ZSHDIR) $(MAN1DIR) $(MAN7DIR)
	install -m755 bin/* $(BINDIR)/
	install -m644 conf/* $(ETCDIR)/
	install -m644 app/* $(LIBDIR)/app/
	install -m644 core/* $(LIBDIR)/core/
	install -m644 wm/* $(LIBDIR)/wm/
	install -m644 completion/zsh/_ws-session $(ZSHDIR)/
	install -m644 man/ws-session.1 $(MAN1DIR)/
	install -m644 man/ws-session.7 $(MAN7DIR)/
	@sed -i "/VERSION/s/VERSION=/VERSION=\"$(VERSION)\"/" "$(BINDIR)/ws-session"
	@sed -i "/VERSION/s/VERSION/$(VERSION)/" "$(MAN1DIR)/ws-session.1"
	@sed -i "/VERSION/s/VERSION/$(VERSION)/" "$(MAN7DIR)/ws-session.7"
