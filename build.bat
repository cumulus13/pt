@echo off

cargo build --release
if %errorlevel%==0 goto success
if %errorlevel%==101 goto compile_error
goto other_error

:success
echo Build successfully!
copy /y target\release\*.exe .
goto end

:compile_error
echo Error: compilation failed (code 101)!
goto end

:other_error
echo Another error occurred, code: %errorlevel%
goto end

:end
