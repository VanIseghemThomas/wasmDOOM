import Module from '../wasm/wasm-doom.js';

let canvas = document.getElementById('canvas');
canvas.width = 320;
canvas.height = 200;
canvas.style.cursor = 'none';
document.body.appendChild(canvas);

// As a default initial behavior, pop up an alert when webgl context is lost. To make your
// application robust, you may want to override this behavior before shipping!
// See http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.15.2
canvas.addEventListener("webglcontextlost", (e) => { alert('WebGL context lost. You will need to reload the page.'); e.preventDefault(); }, false);

// Create a canvas element and attach it to the body
let module_args = {
    canvas: canvas,
    // From https://emscripten.org/docs/porting/files/packaging_files.html?#changing-the-data-file-location
    // It states that the default location is the same as where the wasm file is hosted, this is not the case for us
    // it will only work out of the box if the wasm file is in the same directory as the html index
    // so we need to specify the location of the wasm file
    locateFile: (remote_package_base, _) => {
        return 'wasm/' + remote_package_base;
    }
}

let doom = await Module(module_args);
console.log(doom);
// Assuming we have a doom1.wad file in the repo root and compiled it with wasm-doom
// to the virtual filesystem at /doom-data.wad
doom.callMain(['-iwad', 'doom-data.wad']);