@echo off

REM // ubicacion del compilador
set _ppc="C:\FPC\2.4.2\bin\i386-win32\ppc386.exe"

REM ;-------------------------------------------------------------------------------------------------
 
REM // nombre de nuestro pas a compilar

REM ; ejemplo _pas=programa

set _pas=Balanceado

REM ;-------------------------------------------------------------------------------------------------


REM // asignarle a _path la ruta del .pas en caso que el .pas no esté en la misma carpeta donde se aloja este .bat;

REM ;// ejemplo: supongamos que "compilar.bat" se encuentra en "c:\" y nuestro .pas a compilar esta en "c:\parciales\program.pas" 
REM ;// entonces _path deberia ser: 
REM ;// _path=C:\parciales\

REM set _path=D:\Programacion\Projects\IntroProg2\Final 19-5-09\


REM ;// En el caso que nuestro .pas esta en la misma carpeta que "compilar.bat" podemos dejar la linea anterior como lo siguiente

REM ;// set _path=

REM NOTa: Asignarle la ruta correcta a _path nos sera util para cuando ejecutemos a "compilar.bat" desde otra ubicacion
REM       o por ejemplo si lo llamamos con la tecla F5 desde Notepad++    

REM ;--------------------------------------------------------------------------------------------------

:checkppc
if EXIST %_ppc% goto checkpas
echo esta Free Pascal Team instalado?
echo el archivo %_ppc% no existe, debe editar este archivo por lotes para especificar la ruta correcta. 
pause > nul
exit
	
:checkpas
if EXIST "%_path%%_pas%.pas" goto compile
echo %_pas%.pas no se encuentra en el directorio actual
echo (%_path%%_pas%)
set /p _pas=ingrese el nombre del archivo a compilar: 
goto checkpas
	
:compile
cls
echo Compilando: %_path%%_pas%.pas
echo.
echo ------------------------------------------
%_ppc% "%_path%%_pas%.pas"

IF %errorlevel% == 0 GOTO GG
%_ppc% "%_path%%_pas%.pas" > error%_pas%.txt
echo ------------------------------------------
echo El error fue guardado en error%_pas%.txt. Presione una tecla para terminar.

choice /m "compilar devuelta?" 
IF  %errorlevel% == 1 goto compile
exit
 	

:THEEND
choice /T 5 /D S /M "desea ejecutar el exe? (respuesta default: "Si" en 5 segundos)"   
IF  %errorlevel% == 1 goto exe
exit

:again
echo.
choice /M "Desea ejecutarlo nuevamente?"
if %errorlevel% == 1 goto exe
choice /M "Desea compilarlo nuevamente?"
if %errorlevel% == 1 goto compile
exit

:saved
echo El texto generado por el programa se ha guardado en
echo %_path%exeresult.txt
pause > nul
goto again

:tofile
cls
echo recuerde que la salida del programa esta siendo escrito en un archivo, 
echo si el programa esta en espera de un readkey / readln usted debe presionarla por mas que la pantalla este en negro.
echo Al finalizar la ejecucion del programa se informara que el archivo ha sido guardado en exeresult.txt.
echo presione una tecla para continuar..
pause > nul
cls
"%_path%%_pas%.exe" > "%_path%exeresult.txt"
if EXIST "%_path%exeresult.txt" goto saved
echo No se pudo guardar en %_path%exeresult.txt el texto producido por el programa.
pause > nul
goto again


:exe
echo.
choice /M "Desea que se imprima en pantalla? (poner N para que la salida sea en un archivo de texto)"
if %errorlevel% == 2 goto tofile
cls
echo exe:
echo ---------------------------------------------------
echo.
"%_path%%_pas%.exe" 
echo.
echo ---------------------------------------------------
echo fin del exe.
goto again
exit

:GG
echo.
echo "Perfect!"
echo "0 Errors"
echo.
REM echo "0 Warnings"
IF EXIST %_pas%.txt erase %_pas%.txt

goto theend
