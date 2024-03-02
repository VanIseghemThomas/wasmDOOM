#!/bin/bash
mdkir -p ./public/wasm
docker build . -t wasm-doom-builder
docker run -it -v $PWD/public/wasm:/opt/dist -v $PWD/src:/opt/src wasm-doom-builder