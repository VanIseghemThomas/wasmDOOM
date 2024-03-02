# wasmDOOM
Adaption of the original DOOM ported to run in a WASM environment.
This project is for educational purposes and learned me the basics of taking an existing project, that in particular includes graphics rendering, and porting it to WASM.
![image](https://github.com/VanIseghemThomas/wasmDOOM/assets/55881698/79777d10-50fe-4521-bdbc-1dcd82395a91)


# Building
## Dependencies
The easy way is to go to `intallers` and run:
```
install_deps_<target-platform>.sh
```

Or you can do the manual way below:
### Emscriptem
From the [official docs](https://emscripten.org/docs/getting_started/downloads.html):
```
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
```

### SDL 2 (MacOS)
```
brew install SDL2
brew install SDL2_image
brew install SDL2_ttf
```

## Compile
(Temporary until I get a WAD loader working)
We need to also compile the game assets inside the application for now. For this you will need a so called "where all data" .wad file. I got mine [from here](http://sauparna.sdf.org/Doom/Compile_Doom) and is tested working. You can just put it in the root of the repository, or somewhere you like.

To build the project simply run:
```
PRELOAD_WAD=<wad-file-location> make
```
Then you can host a simple web server to serve the page. I always use a simple python module for this:

# Serving
```
cd public
python3 http.server (optional: -p <some-custom-port>)
```

Now DOOM should be available on `localhost`

# Limitations:
Note: this does not mean I wont look into resolving this in the future. I will do my absolute best to get as close as possible to a native gaming experience.
- No support for audio
- No controller support (only tested on mobile)
- Persistent save between reloads
- Project build only tested and developed on MacOS

# Credits / sources
I can't take credit for al the work here. This repository is based on the work done by [sdl2-doom](https://github.com/AlexOberhofer/sdl2-doom) which is modified to work with the [SDL2 library](https://www.libsdl.org/) also known as the Simple DirectMedia Layer. This library makes it easy to interact with video, audio, input hardware and has excellent support for WASM.

As for understanding how to compile to WASM, the following resources were a big help:
- https://web.dev/articles/compiling-mkbitmap-to-webassembly
- https://web.dev/articles/drawing-to-canvas-in-emscripten

The first one is a really good reference on how to get started and how arguments/file access are handled.
The second one being an excelent reference on how to interact with SDL2 and drawing to the canvas.

