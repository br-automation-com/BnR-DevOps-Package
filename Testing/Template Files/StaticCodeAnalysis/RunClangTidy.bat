@echo off
echo Generating JSON
set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:"=%
set ProjectPath=%1
set ProjectPath=%ProjectPath:"=%
set TempPath=%ProjectPath%\Temp
Powershell -ExecutionPolicy ByPass -file "%ScriptPath%Set-JsonDatabase.ps1" "%ProjectPath%" "%2" "%TempPath%\compile_commands.json" "%TempPath%\file_list.txt"
echo Running Clang-Tidy
set /p Files=<"%TempPath%\file_list.txt"
"C:\Program Files\LLVM\bin\clang-tidy.exe" -p="%TempPath%" --config-file="%ScriptPath%clang-tidy.opt" %Files% 
