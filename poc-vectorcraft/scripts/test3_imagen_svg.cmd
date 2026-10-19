@echo off
REM PoC VectorCraft paso 3: (a) generar "logo" con formas, (b) colocarlo en otra pieza, (c) exportar SVG
set "CLI=C:\Program Files\VectorCraft\vectorcraft-cli.exe"
set "RES=D:/dev/Node.js/InsanoNetwork/proyectos/08-msd/poc-vectorcraft/results"

echo --- RUN A: logo de prueba (shapes) ---
"%CLI%" run --cmd file.new --params "{""width"":400,""height"":400,""units"":""Pixels""}" ^
  --cmd shape.ellipse --params "{""x"":100,""y"":80,""width"":200,""height"":200}" ^
  --cmd paint.setFill --params "{""color"":""#e93d82""}" ^
  --cmd shape.rectangle --params "{""x"":140,""y"":165,""width"":120,""height"":30,""radius"":15}" ^
  --cmd paint.setFill --params "{""color"":""#ffffff""}" ^
  --cmd text.create --params "{""x"":130,""y"":310,""text"":""MARCA"",""size"":48,""color"":""#1a1a2e""}" ^
  --export "%RES%/logo_prueba.png" ^
  --cmd document.save --params "{""path"":""%RES%/logo_prueba.vectorcraft""}"
echo EXIT_A %ERRORLEVEL%

echo --- RUN B: pieza con logo incrustado (file.place), exportar PNG + SVG ---
"%CLI%" run --cmd file.new --params "{""width"":1080,""height"":1080,""units"":""Pixels""}" ^
  --cmd shape.rectangle --params "{""x"":0,""y"":0,""width"":1080,""height"":1080}" ^
  --cmd paint.setFill --params "{""color"":""#f5f5f5""}" ^
  --cmd file.place --params "{""path"":""D:/dev/Node.js/InsanoNetwork/proyectos/08-msd/poc-vectorcraft/results/logo_prueba.png"",""at"":[540,420]}" ^
  --cmd text.create --params "{""x"":340,""y"":700,""text"":""Promo con logo"",""size"":64,""color"":""#1a1a2e""}" ^
  --export "%RES%/pieza_logo.png" --export "%RES%/pieza_logo.svg"
echo EXIT_B %ERRORLEVEL%
