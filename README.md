# template-sdcc-msx
This is a template to start develping MSX software, including several startups to create many kind of ROM and MSX-DOS files.

Current startup list:
* ROM 16kb (init: 0x4000)
* ROM 16kb (init: 0x8000)
* ROM 32Kb (init: 0x4000)
* MSX-DOS COM file (simple main)
* MSX-DOS COM file (main with arguments)

## Compiling
```
make all      ;Compile and build
make compile  ;Just compile the project
make build    ;Build the final file (ROM|COM)
make emulator ;Launch the final file with openmsx
```
## Thanks
- [Alberto de Hoyo Nebot](http://albertodehoyonebot.blogspot.com.es/p/how-to-create-msx-roms-with-sdcc.html])
- [Avelino Herrera Morales](http://msx.atlantes.org/index_en.html])
- [Laurens Holst](http://map.grauw.nl/)
