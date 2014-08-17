.PHONY: test

# target:  help       - Display targets
help :
	@echo "Makefile for session"
	@echo
	@echo "Targets:"
	@egrep "^# target:" [Mm]akefile | cut -d":" -f2
	

# target:  test       - Run the tests
test:
	@bash test/test-core-data.sh
	@bash test/test-core-wm.sh


# target:  install    - Install
install:
	mkdir -p "$(DESTDIR)$(PREFIX)/lib/ws-session/"
	mkdir -p "$(DESTDIR)/etc/xdg/ws-session/"
	mkdir -p "$(DESTDIR)$(PREFIX)/bin"
	cp -pr core "$(DESTDIR)$(PREFIX)/lib/ws-session/core"
	cp -pr app "$(DESTDIR)$(PREFIX)/lib/ws-session/app"
	cp -pr wm  "$(DESTDIR)$(PREFIX)/lib/ws-session/wm"
	cp -pr bin "$(DESTDIR)/etc/xdg/ws-session/bin"
	cp -p ws-session "$(DESTDIR)$(PREFIX)/bin/ws-session"
	cp -p ws-session.rc "$(DESTDIR)/etc/xdg/ws-session/ws-session.rc"

