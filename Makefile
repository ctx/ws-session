.PHONY: test depts

VERSION:=$(shell git rev-list --count HEAD) (git)
LIBDIR:=$(DESTDIR)$(PREFIX)/lib/ws-session
BINDIR:=$(DESTDIR)$(PREFIX)/bin
ETCDIR:=$(DESTDIR)/etc/xdg/ws-session

# target:  help       - Display this help
help :
	@echo "Makefile for ws-session"
	@echo
	@echo "There is no need to compile, this are some install routines:"
	@egrep "^# target:" [Mm]akefile | cut -d":" -f2
	

# target:  test       - Run the core tests (data,wm (just the running one)) 
test:
	@bash test/test-core-data.sh
	@bash test/test-core-wm.sh


# target:  version    - Show version
version:
	@echo $(VERSION)

# target:  depts      - Check for missing dependencies
depts: 
	@which wmctrl
	@which xprop
	@which xdotool

# target:  install    - Install to $(DESTDIR)$(PREFIX)
install: depts
	install -d $(LIBDIR)/core $(LIBDIR)/app $(LIBDIR)/wm $(BINDIR) $(ETCDIR)/bin
	install -m755 ws-session $(BINDIR)/
	install -m644 ws-session.rc $(ETCDIR)/
	install -m644 app/* $(LIBDIR)/app
	install -m755 bin/* $(ETCDIR)/bin
	install -m644 core/* $(LIBDIR)/core
	install -m644 wm/* $(LIBDIR)/wm
	@sed -i "/VERSION/s/VERSION=/VERSION=\"$(VERSION)\"/" "$(BINDIR)/ws-session"
