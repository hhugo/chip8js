.PHONY: script all launch sass clean

all:
	@ocamlbuild chip8.otarget
	@cp _build/chip8.js public

script:
	@Make -C script

launch: script
	ocsigenserver -c chip8.conf

sass:
	@compass compile ./css
	@cp -r ./css/css/ ./public


clean:
	rm -rf _build
