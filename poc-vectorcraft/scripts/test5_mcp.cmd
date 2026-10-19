@echo off
REM PoC paso 5: probar el servidor MCP de VectorCraft por stdio con mensajes JSON-RPC
set "CLI=C:\Program Files\VectorCraft\vectorcraft-cli.exe"
set "IN=%~dp0test5_mcp_input.jsonl"
set "OUT=%~dp0test5_mcp_out.jsonl"
"%CLI%" mcp --headless < "%IN%" > "%OUT%" 2> "%~dp0test5_mcp_stderr.txt"
echo EXITCODE %ERRORLEVEL%
