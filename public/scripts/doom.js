import Module from '../wasm/wasm-doom.js';

let canvas = document.getElementById('canvas');
canvas.width = 320;
canvas.height = 200;
canvas.style.cursor = 'none';
canvas.style.display = 'none';

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


function validateWadFile(buffer) {
    // Check if the file is valid by checking the first 4 bytes of the file
    // if they are not 'IWAD' then the file is not valid
    // If the buffer is empty or the file is not a valid WAD file
    if (buffer.length === 0 || buffer.length < 4) {
        console.error('Empty buffer');
        return false;
    }
    if (String.fromCharCode(buffer[0], buffer[1], buffer[2], buffer[3]) !== 'IWAD') {
        console.error('Invalid WAD file');
        return false;
    }
    return true;
}

let doom = await Module(module_args);
let fileUpload = document.getElementById('wad-upload');
fileUpload.addEventListener('change', (e) => { 
    let file = e.target.files[0];
    let reader = new FileReader();
    reader.onload = (e) => {
        let buffer = new Uint8Array(e.target.result);
        let errorLabel = document.querySelector('.error-label');
        if (!validateWadFile(buffer)) {
            errorLabel.style.display = 'block';
            return;
        }
        errorLabel.style.display = 'none';
        canvas.style.display = 'block';
        doom.FS.writeFile('/doom-data.wad', buffer);
        doom.callMain(['-iwad', 'doom-data.wad']);
    }
    reader.readAsArrayBuffer(file);
    console.log('file uploaded');
});


document.addEventListener("fullscreenchange", () => {
    if (document.fullscreenElement) {
        console.log("Application is now in fullscreen mode");
    } else {
        console.log("Application exited fullscreen mode");
        canvas.style.display = 'none';
        document.body.style.background = '';
    }
});


