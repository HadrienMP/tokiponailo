elm make src/Main.elm --output=dist/main.js --optimize
cp -r ./public/* ./dist
zip -r ./dist/dist.zip ./dist/*