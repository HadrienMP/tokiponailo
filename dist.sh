elm make src/Main.elm --output=dist/main.js --optimize
cp -r ./public/* ./dist
zip ./dist/dist.zip ./dist/*