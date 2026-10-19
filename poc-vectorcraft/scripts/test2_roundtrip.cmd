@echo off
REM PoC VectorCraft paso 2 (round-trip): guardar .vectorcraft, reabrir, cambiar color y texto, reexportar
REM NOTA: los paths dentro de --params JSON usan "/", el backslash es escape invalido en JSON
set "CLI=C:\Program Files\VectorCraft\vectorcraft-cli.exe"
set "RES=%~dp0..\results"

echo --- RUN A: crear documento y guardar como .vectorcraft ---
"%CLI%" run --cmd file.new --params "{""width"":1080,""height"":1080,""units"":""Pixels""}" ^
  --cmd shape.rectangle --params "{""x"":0,""y"":0,""width"":1080,""height"":1080}" ^
  --cmd paint.setFill --params "{""color"":""#1a1a2e""}" ^
  --cmd shape.ellipse --params "{""x"":360,""y"":280,""width"":360,""height"":300}" ^
  --cmd paint.setFill --params "{""color"":""#e93d82""}" ^
  --cmd text.create --params "{""x"":140,""y"":760,""text"":""PIEZA ORIGINAL"",""size"":72,""color"":""#ffffff""}" ^
  --cmd document.save --params "{""path"":""D:/dev/Node.js/InsanoNetwork/proyectos/08-msd/poc-vectorcraft/results/roundtrip.vectorcraft""}"
echo EXIT_A %ERRORLEVEL%

echo --- INFO del archivo guardado ---
"%CLI%" info "%RES%\roundtrip.vectorcraft"
echo EXIT_INFO %ERRORLEVEL%

echo --- RUN B: reabrir, editar color de elipse (id 3) y texto, reexportar ---
"%CLI%" run --in "%RES%\roundtrip.vectorcraft" ^
  --cmd paint.setFill --params "{""color"":""#2266aa"",""ids"":[3]}" ^
  --cmd text.setText --params "{""id"":4,""text"":""PIEZA EDITADA""}" ^
  --export "%RES%\roundtrip_edited.png" ^
  --cmd document.save --params "{""path"":""D:/dev/Node.js/InsanoNetwork/proyectos/08-msd/poc-vectorcraft/results/roundtrip_edited.vectorcraft""}"
echo EXIT_B %ERRORLEVEL%
