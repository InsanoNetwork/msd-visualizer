@echo off
REM PoC VectorCraft paso 1 (corregido): headless - documento 1080x1080, rectangulo + elipse + texto, exportar PNG
set "CLI=C:\Program Files\VectorCraft\vectorcraft-cli.exe"
set "OUT=%~dp0..\results\test1_headless.png"

"%CLI%" run --cmd file.new --params "{""width"":1080,""height"":1080,""units"":""Pixels""}" ^
  --cmd shape.rectangle --params "{""x"":0,""y"":0,""width"":1080,""height"":1080}" ^
  --cmd paint.setFill --params "{""color"":""#1a1a2e""}" ^
  --cmd shape.ellipse --params "{""x"":360,""y"":280,""width"":360,""height"":300}" ^
  --cmd paint.setFill --params "{""color"":""#e93d82""}" ^
  --cmd text.create --params "{""x"":140,""y"":760,""text"":""POC HEADLESS OK"",""size"":72,""color"":""#ffffff""}" ^
  --export "%OUT%"
echo EXITCODE %ERRORLEVEL%
