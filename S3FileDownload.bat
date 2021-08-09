@echo off
echo Usage:
echo ---------------------------------------------------------------------------------------------------------------------------------------------------
echo please install AWS cli version 2
echo provide parameters for a time range and execute the command: 
echo valid command: script_name parameter1(start date) parameter2(end date) parameter3(file type) parameter4(prefered downloading frequency: valid value: 1~10)
echo valid file type: all csv attachment
echo sample valid command: S3fileDownload 2020-02-03 2020-02-04 all 3
echo parameter4:configure the amount of files that you would like to download at the same time(it can be use to improve the download speed) 
echo aws2 s3api list-objects-v2 --bucket qa2-trunk-be-integration--service --prefix parameter3 --query "Contents[?(LastModified>='parameter1' && LastModified<='parameter2')].Key"
echo ---------------------------------------------------------------------------------------------------------------------------------------------------
SET folder=%3
IF %folder% EQU all aws2 s3api list-objects-v2 --bucket {bucketName}  --query "Contents[?(LastModified>='%1' && LastModified<= '%2')].Key" > a.txt
IF %folder% EQU attachment aws2 s3api list-objects-v2 --bucket {bucketName}  --prefix attachment  --query "Contents[?(LastModified>='%1' && LastModified<= '%2')].Key" > a.txt
IF %folder% EQU csv aws2 s3api list-objects-v2 --bucket {bucketName}  --prefix csv  --query "Contents[?(LastModified>='%1' && LastModified<= '%2')].Key" > a.txt
setlocal EnableExtensions DisableDelayedExpansion
rem // Write output to another file:
> "b.txt" (
    rem /* Read file by `more` which replaces TABs by SPACEs;
    rem    then parse the output by `for /F` (skipping empty lines): */
    for /F delims^=^ eol^= %%L in ('more "a.txt"') do (
        rem // Store current (non-empty) line:
        set "LINE=%%L"
        rem /* Toggle delayed expansion to be able to write and read
        rem    a variable in the same block of code and to preserve `!`: */
        setlocal EnableDelayedExpansion
        rem // Replace every SPACE by nothing, hence remove it
        echo(!LINE: =!
        endlocal
    )
)
endlocal
cls
setlocal EnableDelayedExpansion
SET "cmd=findstr /R /N "^^" b.txt | find /C ":""
FOR /f %%a in ('!cmd!') do set numberOfLines=%%a

SET g=1
SET b=%4
SET /a d=%b%-%g%
SET numOfSyntax=2
SET /a totalLines = %numberOfLines%-%numOfSyntax%
SET /a count= %totalLines%/%d%+%g%
SET /a c=-1
SET /a i=0
SET l=10
FOR /F "eol=] delims=, skip=1 tokens=1 usebackq" %%i in (b.txt) do (
  set /a c=c+1 & set arr[!c!]=%%~i
) 
goto loop
:loop
IF %b% GTR %l% ECHO The prefered downloading frequency is invalid(1~10) & goto:eof
IF DEFINED b (ECHO start downloading...) ELSE (ECHO The prefered downloading frequency has not been specify, please retry... & goto:eof)
FOR /L %%s in (%i%,1,%d%) do ( start /min aws2 s3 cp s3://qa2-trunk-be-integration--service/!arr[%%s]! .  &  IF DEFINED arr[%%s]  echo s3 download !arr[%%s]!  ) 
SET /a i=i+%b% 
SET /a d=d+%b% 
IF !i! LSS !c! ECHO next.. & goto loop
IF !i! EQU !c! ECHO next.. & goto loop
IF !i! GTR !c! ECHO end.. & goto:eof
endlocal

