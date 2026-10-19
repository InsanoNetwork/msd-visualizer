@echo off
REM PoC paso 11: acentos/unicode via stdio (probar que JSON-RPC UTF-8 pasa intacto)
set "CLI=C:\Program Files\VectorCraft\vectorcraft-cli.exe"
set "IN=%~dp0test7_mcp_unicode_input.jsonl"
set "OUT=%~dp0test7_mcp_unicode_out.jsonl"
"%CLI%" mcp --headless < "%IN%" > "%OUT%" 2> nul
echo EXITCODE %ERRORLEVEL%
