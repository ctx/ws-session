.PHONY: test

# target:  help       - Display targets
help :
	@echo "Makefile for session"
	@echo
	@echo "Targets:"
	@egrep "^# target:" [Mm]akefile | cut -d":" -f2
	

# target:  test       - Run the tests
test:
	@bash test/test-lib-wm.sh
	@bash test/test-lib-data.sh


# target:  install    - Install
install:
	mkdir -p "$(DESTDIR)$(PREFIX)/lib/ws-session/"
	mkdir -p "$(DESTDIR)/etc/xdg/ws-session/"
	mkdir -p "$(DESTDIR)$(PREFIX)/bin"
	cp -pr lib "$(DESTDIR)$(PREFIX)/lib/ws-session/lib"
	cp -pr app "$(DESTDIR)$(PREFIX)/lib/ws-session/app"
	cp -pr wm  "$(DESTDIR)$(PREFIX)/lib/ws-session/wm"
	cp -pr bin "$(DESTDIR)/etc/xdg/ws-session/bin"
	cp -p ws-session "$(DESTDIR)$(PREFIX)/bin/ws-session"
	cp -p ws-session.rc "$(DESTDIR)/etc/xdg/ws-session/ws-session.rc"

# target:  uninstall  - Uninstall
uninstall:
	rm -f $(DESTDIR)$(BINDIR)/ws-session
	rm -f $(DESTDIR)/etc/xdg/ws-session
	rm -f $(DESTDIR)/usr/bin/ws-session
