@echo off
REM Flujo prompt->pieza: "Crea un poster 1080x1080 para Cafeteria Amanecer..."
REM Secuencia = misma que el agente llamaria via MCP tools (draw_shape, add_text, export...)
set "CLI=C:\Program Files\VectorCraft\vectorcraft-cli.exe"
set "RES=D:/dev/Node.js/InsanoNetwork/proyectos/08-msd/poc-vectorcraft/results"

"%CLI%" run --cmd file.new --params "{""width"":1080,""height"":1080,""units"":""Pixels""}" ^
 --cmd shape.rectangle --params "{""x"":0,""y"":0,""width"":1080,""height"":1080}" ^
 --cmd paint.setFill --params "{""color"":""#f3ead7""}" ^
 --cmd shape.ellipse --params "{""x"":340,""y"":200,""width"":400,""height"":400}" ^
 --cmd paint.setFill --params "{""color"":""#6f4e37""}" ^
 --cmd shape.rectangle --params "{""x"":420,""y"":330,""width"":240,""height"":140,""radius"":18}" ^
 --cmd paint.setFill --params "{""color"":""#f3ead7""}" ^
 --cmd path.create --params "{""d"":""M660 360 h70 a45 45 0 0 1 0 90 h-70""}" ^
 --cmd paint.setFill --params "{""none"":true}" ^
 --cmd paint.setStroke --params "{""color"":""#6f4e37""}" ^
 --cmd stroke.set --params "{""width"":16}" ^
 --cmd shape.ellipse --params "{""x"":560,""y"":150,""width"":90,""height"":46}" ^
 --cmd paint.setFill --params "{""color"":""#f3ead7""}" ^
 --cmd text.create --params "{""x"":140,""y"":620,""text"":""AMANECER"",""size"":110,""color"":""#3b2b20""}" ^
 --cmd text.create --params "{""x"":250,""y"":740,""text"":""Café de especialidad"",""size"":44,""color"":""#7a5c44""}" ^
 --cmd shape.rectangle --params "{""x"":290,""y"":840,""width"":500,""height"":90,""radius"":45}" ^
 --cmd paint.setFill --params "{""color"":""#e93d82""}" ^
 --cmd text.create --params "{""x"":400,""y"":868,""text"":""2x1 esta semana"",""size"":40,""color"":""#ffffff""}" ^
 --export "%RES%/flujo_poster_amanecer.png" ^
 --export "%RES%/flujo_poster_amanecer.svg" ^
 --cmd document.save --params "{""path"":""%RES%/flujo_poster_amanecer.vectorcraft""}"
echo EXITCODE %ERRORLEVEL%
