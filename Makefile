.PHONY: test deps

VERSION:=$(shell git rev-list --count HEAD) (git)
LIBDIR:=$(DESTDIR)$(PREFIX)/lib/ws-session
BINDIR:=$(DESTDIR)$(PREFIX)/bin
ETCDIR:=$(DESTDIR)/etc/xdg/ws-session
ZSHDIR:=$(DESTDIR)/usr/share/zsh/site-functions

# target:  help       - Display this help
help :
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
	@echo $(VERSION)

# target:  deps       - Check for missing dependencies
deps:
	@which wmctrl
	@which xprop
	@which xdotool

# target:  install    - Install to $(DESTDIR)$(PREFIX)
install: deps
	install -d $(LIBDIR)/core $(LIBDIR)/app $(LIBDIR)/wm $(BINDIR) $(ETCDIR)/bin $(ZSHDIR)
	install -m755 ws-session $(BINDIR)/
	install -m644 ws-session.rc $(ETCDIR)/
	install -m644 app/* $(LIBDIR)/app
	install -m755 bin/* $(ETCDIR)/bin
	install -m644 core/* $(LIBDIR)/core
	install -m644 wm/* $(LIBDIR)/wm
	install -m644 completion/zsh/_ws-session $(ZSHDIR)/
	@sed -i "/VERSION/s/VERSION=/VERSION=\"$(VERSION)\"/" "$(BINDIR)/ws-session"
