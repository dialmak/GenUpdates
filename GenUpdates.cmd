:: by dialmak 25.10.2016
@echo off
pushd "%~dp0"
setlocal enableextensions enabledelayedexpansion
color 1f
set "ver=Generator CMD Scripts Updates v1.2"
echo            %ver%
echo            ----------------------------------
echo+
call :GetINI
call :ParseParam
set title=%ver% for folder %update_folder%
title %title%
pushd "%~dp0%update_folder%" && popd || (echo Ошибка. Папка "%~dp0%update_folder%" не найдена. & goto :Exit)
dir "%update_folder%" /a:-d /b %sort_list% %sort_time% | findstr /e "%filter_ext%" > "%temp_list%" || (echo Ошибка. Файлы обновлений с расширениями "%filter_ext%" не обнаружены в папке "%~dp0%update_folder%". & goto :Exit)
@echo off>"%filename_list%" || (echo Ошибка. Не получается создать файл "%filename_list%". & goto :Exit)
for /f "usebackq delims=" %%A in ("%temp_list%") do echo "%%A">>"%filename_list%"
(
echo.
echo # Отредактируйте этот список обновлений в текстовом редакторе.
echo # После редактирования и сохранения этого списка вернитесь в окно скрипта.
echo # Затем нажмите любую клавишу и скрипт сформирует CMD файл для вашего списка обновлений...
echo.
echo # Файл в списке должен быть обрамлен двойными кавычками. 
echo # Для пропуска запуска файла - в начале строки поставьте решетку #.
echo # По умолчанию используются следующие строки запуска :
echo #    для .msu файлов - start "" /wait wusa "filename.msu" /quiet /norestart
echo #    для остальных файлов - start "" /wait "filename.ext" /quiet /norestart
echo # Если требуются другие ключи запуска - напишите их после имени файла обновлений.
echo.
)>>"%filename_list%"
echo Список обновлений сформирован.
echo Для начала редактирования файла с списком обновлений нажмите любую клавишу ...
pause > nul
start "" "%text_editor%" "%filename_list%"
ping 127.0.0.1 -n 3 > nul
echo Для формирования CMD файла обновлений для папки "%update_folder%" нажмите любую клавишу ...
pause > nul
call :Creator
start "" "%text_editor%" "%cmd_name%"
ping 127.0.0.1 -n 3 > nul
echo Скрипт закончил работу.
:Exit
echo+
echo Для выхода нажмите любую клавишу ...
pause > nul
exit

:ParseParam
set "xOS=x64"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" if not defined PROCESSOR_ARCHITEW6432 set "xOS=x86"
set "temp_list=%temp%\temp_list_files.txt"

if not defined filename_list (set "filename_list=list_files_!date!.txt")
if not defined filter_ext (set "filter_ext= .msu .exe .cab .msi")
if not defined sort_list (set "sort_list=time")
if not defined sort_time (set "sort_time=3")
if not defined text_editor (
set "text_editor=%windir%\notepad.exe"
if exist "%ProgramFiles%\Notepad++\notepad++.exe" set "text_editor=%ProgramFiles%\Notepad++\notepad++.exe"
if exist "%ProgramFiles(x86)%\Notepad++\notepad++.exe" set "text_editor=%ProgramFiles(x86)%\Notepad++\notepad++.exe"
)

call :Trim update_folder %update_folder%
call :Trim filename_list %filename_list%
call :Trim filter_ext %filter_ext%
call :Trim sort_list %sort_list%
call :Trim text_editor %text_editor%

if defined update_folder if "!update_folder:~0,1!" equ "\" (set "update_folder=!update_folder:~1!")
if defined update_folder if "!update_folder:~-1!" equ "\" (set "update_folder=!update_folder:~,-1!")

if defined update_folder (set "filename_list=%~dp0%update_folder%\%filename_list%") else (set "filename_list=%~dp0%filename_list%")
if not defined update_folder (set "cmd_name=update_!date!.cmd")
if not defined cmd_name (
set "cmd_name=!update_folder: =_!"
set "cmd_name=!cmd_name:\=_!_!date!.cmd"
)

echo update_folder=%update_folder%
rem echo text_editor=%text_editor%
echo cmd_name=%cmd_name%
echo filter_ext=%filter_ext%
echo sort_list=%sort_list%
echo+

if /i "%sort_time%" EQU "1" (set "sort_time=/t:c")
if /i "%sort_time%" EQU "2" (set "sort_time=/t:a")
if /i "%sort_time%" EQU "3" (set "sort_time=/t:w")
if /i "%sort_list%" EQU "abc" (set "sort_time=")
if /i "%sort_list%" EQU "-abc"(set "sort_time=")

if /i "%sort_list%" EQU "time" (set "sort_list=/o:d")
if /i "%sort_list%" EQU "-time" (set "sort_list=/o:-d")
if /i "%sort_list%" EQU "abc" (set "sort_list=/o:n")
if /i "%sort_list%" EQU "-abc" (set "sort_list=/o:-n")

set "cmd_name=%~dp0!cmd_name!"
exit /b

:Trim
setlocal enabledelayedexpansion
set params=%*
if %params:~0,1% EQU [ endlocal & exit /b
for /f "tokens=1*" %%A in ("!params!") do (endlocal & set "%1=%%~B")
exit /b

:GetINI
set "INIFile=%~dp0settings.ini"
if exist "%INIFile%" (
cmd /c type "%INIFile%">"%temp%\settings.ini"
for /f "eol=# skip=1 usebackq tokens=1,2* delims==" %%I in ("%temp%\settings.ini") do (call :Trim %%~I %%~J)
) else (
echo Ошибка. Файл настроек параметров "%INIFile%" не найден.
goto :Exit
)
exit /b

:Creator
(
echo @echo off
echo setlocal enableextensions enabledelayedexpansion
echo color 1F
echo pushd="%%~dp0%update_folder%"
echo set "xOS=x64"
echo if /i "%%PROCESSOR_ARCHITECTURE%%"=="x86" if not defined PROCESSOR_ARCHITEW6432 set "xOS=x86"
echo call :en-US
echo set langkey="HKLM\SYSTEM\CurrentControlSet\Control\Nls\Language"
echo for /f "tokens=3 delims= " %%%%A in ^('reg query %%langkey%% /v InstallLanguage 2^^^>nul'^) do ^(if %%%%A EQU 0419 call :ru-RU^)
echo set title=%%mes01%% "%update_folder%"
echo title %%title%%
echo set /a num=0
echo set /a err=0
echo call :GetAdminRights
echo echo.
echo echo            %%title%%
echo echo+ ------------------------------------------------------------------------------
for /f eol^=#^ usebackq^ tokens^=1^,*^ delims^=^" %%A in ("%filename_list%") do (	
	if /i [%%B] NEQ [] if /i [%%~xA] EQU [.msu] (
		set /a num+=1 
		echo echo+ !num!. %%mes02%% "%%~A" ...
		echo start "" /wait wusa "%%~A" %%B
		echo call :GetErrorCode)		
	if /i [%%B] EQU [] if /i [%%~xA] EQU [.msu] (
		set /a num+=1 
		echo echo+ !num!. %%mes02%% "%%~A" ...
		echo start "" /wait wusa "%%~A" /quiet /norestart
		echo call :GetErrorCode)		
	if /i [%%B] NEQ [] if /i [%%~xA] NEQ [.msu] (
		set /a num+=1 
		echo echo+ !num!. %%mes02%% "%%~A" ...
		echo start "" /wait "%%~A" %%B
		echo call :GetErrorCode)
	if /i [%%B] EQU [] if /i [%%~xA] NEQ [.msu] (
		set /a num+=1 
		echo echo+ !num!. %%mes02%% "%%~A" ...
		echo start "" /wait "%%~A" /quiet /norestart
		echo call :GetErrorCode)	
		)
echo echo+ ------------------------------------------------------------------------------	
echo+
echo set /a inst=%%num%%-%%err%%
echo echo+ %%mes03%% = %%inst%%
echo echo+ %%mes04%% = %%err%%
echo echo+ %%mes05%% = %%num%%
echo echo.
echo echo+ %%mes06%%
echo pause ^> nul
echo popd
echo exit
echo+
echo :GetAdminRights
echo date %%date%% ^>nul 2^>^&1 ^|^| ^(
echo     echo Set UAC = CreateObject^^^("Shell.Application"^^^) ^> "%%temp%%\GetAdmin.vbs"
echo     echo UAC.ShellExecute "%%~f0", "", "", "runas", 1 ^>^> "%%temp%%\GetAdmin.vbs"
echo     %%ComSpec%% /u /c type "%%temp%%\GetAdmin.vbs" ^> "%%temp%%\GetAdminUnicode.vbs"
echo     %%windir%%\system32\cscript //nologo "%%temp%%\GetAdminUnicode.vbs"
echo     del /f /q "%%temp%%\GetAdmin.vbs" ^> nul 2^>^&1
echo     del /f /q "%%temp%%\GetAdminUnicode.vbs" ^> nul 2^>^&1
echo     exit
echo ^)
echo exit /b
echo+
echo :GetErrorCode
echo call :DecToHex %%errorlevel%% hexval
echo set /a num+=1
echo if %%hexval%% EQU 0x00000000 ^(echo %%mes07%% ^^^(%%hexval%%^^^) ^& exit ^/b^)
echo if %%hexval%% EQU 0x00000BC2 ^(echo %%mes08%% ^^^(%%hexval%%^^^) ^& exit /b^)
echo if %%hexval%% EQU 0x00009C48 ^(echo %%mes09%% ^^^(%%hexval%%^^^)^&set /a err+=1 ^& exit /b^)
echo if %%hexval%% EQU 0x00240006 ^(echo %%mes09%% ^^^(%%hexval%%^^^)^&set /a err+=1 ^& exit /b^)
echo if %%hexval%% EQU 0x80240017 ^(echo %%mes10%% ^^^(%%hexval%%^^^)^&set /a err+=1 ^& exit /b^)
echo if %%hexval%% EQU 0x00000002 ^(echo %%mes11%% ^^^(%%hexval%%^^^)^&set /a err+=1 ^& exit /b^)
echo echo %%mes12%% ^^^(%%hexval%%^^^) ^& set /a err+=1
echo exit /b
echo+
echo :DecToHex
echo call %%ComSpec%% /c exit /b %%~1
echo set hexval=%%=exitcode%%
echo set "%%~2=0x%%hexval%%"
echo exit /b
echo+
echo :ru-Ru
echo set "mes01=Установка обновлений Windows для папки"
echo set "mes02=Инсталляция"
echo set "mes03=Успешно"
echo set "mes04=Ошибок "
echo set "mes05=Всего  "
echo set "mes06=Перезагрузите свой компьютер для завершения инсталляции обновлений ..."
echo set "mes07=Обновление установлено"
echo set "mes08=Обновление установлено, требуется перегрузка"
echo set "mes09=Установка этого обновления была выполнена ранее"
echo set "mes10=Обновление неприменимо к этому компьютеру"
echo set "mes11=Файл обновления не найден"
echo set "mes12=Ошибка установки обновления"
echo exit /b
echo :en-US
echo set "mes01=Install Updates for Windows for folder"
echo set "mes02=Installing"
echo set "mes03=Success"
echo set "mes04=Error  "
echo set "mes05=All    "
echo set "mes06=Please reboot your computer to complete installation ..."
echo set "mes07=Installation completed successfully"
echo set "mes08=The system must be restarted to complete installation of the update"
echo set "mes09=The update to be installed is already installed on the system"
echo set "mes10=The update does not apply to this computer"
echo set "mes11=The update file is not found"
echo set "mes12=Error updating"
echo exit /b
) > "%cmd_name%"
exit /b
