@echo off
REM PoC VectorCraft paso 4: lote de 5 piezas secuenciales (estilo igual, texto/color distinto)
set "CLI=C:\Program Files\VectorCraft\vectorcraft-cli.exe"
set "RES=D:/dev/Node.js/InsanoNetwork/proyectos/08-msd/poc-vectorcraft/results"
setlocal enabledelayedexpansion
set COLORS=#1a1a2e #1a2a4e #2e1a3e #1a3e2a #3e1a1a
set ACCENTS=#e93d82 #2266aa #e9aa3d #3de96a #e93d3d
set N=0
for %%c in (%COLORS%) do (
  set /a N+=1
  for %%a in (%ACCENTS%) do (
    if not defined DONE_!N! (
      set "DONE_!N!=1"
      set "FN=00!N!"
      set "FN=!FN:~-2!"
      echo --- pieza !FN! ---
      "%CLI%" run --cmd file.new --params "{""width"":1080,""height"":1080,""units"":""Pixels""}" ^
        --cmd shape.rectangle --params "{""x"":0,""y"":0,""width"":1080,""height"":1080}" ^
        --cmd paint.setFill --params "{""color"":""%%c""}" ^
        --cmd shape.ellipse --params "{""x"":360,""y"":280,""width"":360,""height"":300}" ^
        --cmd paint.setFill --params "{""color"":""%%a""}" ^
        --cmd text.create --params "{""x"":140,""y"":760,""text"":""Lote pieza !FN!"",""size"":72,""color"":""#ffffff""}" ^
        --export "%RES%/lote_piece_!FN!.png"
      if errorlevel 1 echo ERROR en pieza !FN!
    )
  )
)
endlocal
echo LOTE COMPLETO
