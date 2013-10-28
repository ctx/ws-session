.PHONY: test

# target: help     - Display targets
help :
	@echo "Makefile for session"
	@echo
	@echo "Targets:"
	@egrep "^# target:" [Mm]akefile | cut -d":" -f2
	

# target: test     - Run the tests
test:
	@bash test/test-lib-wm.sh
	@bash test/test-lib-data.sh


# target: install  - Install 
install:
	mkdir  -p "$(DESTDIR)$(PREFIX)/lib/ws-session/"
	mkdir  -p "$(DESTDIR)/etc/xdg/ws-session/"
	cp -r lib "$(DESTDIR)$(PREFIX)/lib/ws-session/lib"
	cp -r app "$(DESTDIR)$(PREFIX)/lib/ws-session/app"
	cp -r wm  "$(DESTDIR)$(PREFIX)/lib/ws-session/wm"
	cp -r bin "$(DESTDIR)/etc/xdg/ws-session/bin"
	cp ws-session.rc "$(DESTDIR)/etc/xdg/ws-session/ws-session.rc"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/ws-session
	rm -f $(DESTDIR)/etc/xdg/ws-session
