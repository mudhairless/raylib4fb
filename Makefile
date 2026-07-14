build:
	@cd src && make

examples: build
	@cd examples && make

.PHONY clean:
	@cd src && make clean

clean-examples:
	@cd examples && make clean
