# target: help     - Display targets
help :
	@echo "Makefile for session"
	@echo
	@echo "Targets:"
	@egrep "^# target:" [Mm]akefile | cut -d":" -f2
	

# target: test     - Run the tests
test:
	@./test-lib-wm.sh
	@./test-lib-data.sh


# target: install  - Install 
install:
	@echo Installation is not yet implementet
