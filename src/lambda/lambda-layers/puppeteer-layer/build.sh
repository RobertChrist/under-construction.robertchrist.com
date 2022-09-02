#!/bin/sh
rm -rf ./dist/*;
mkdir -p dist/nodejs
cp package.json dist/nodejs
cd dist/nodejs
npm install
cd ..
zip -r puppeteer-layer.zip nodejs
rm -rf ./nodejs