@echo off
setlocal ENABLEDELAYEDEXPANSION

rem Забираем сообщение последнего коммита (без хеша)
for /f "tokens=1,* delims= " %%a in ('git log -1 --oneline 2^>nul') do set "last_msg=%%b"

set "num=0"

if defined last_msg (
    rem Проверяем, что начинается с "Update"
    if /i "!last_msg:~0,6!"=="Update" (
        rem Берём всё после "Update"
        set "rest=!last_msg:~6!"

        rem Обрезаем пробелы
        for /f "tokens=* delims= " %%i in ("!rest!") do set "rest=%%i"

        rem Если дальше только число — берём его
        for /f "delims=0123456789" %%j in ("!rest!") do set "nonnum=%%j"
        if not defined nonnum (
            set "num=!rest!"
        )
    )
)

set /a num+=1
set "msg=Update !num!"

echo Коммитим с сообщением: "!msg!"

git add .
git commit -m "!msg!"
git push

endlocal
