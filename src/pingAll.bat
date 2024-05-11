@REM description: ping ��ǰ��������IP, ��������pingResult.txt, ping 9.1.1.1 ��ʽģ��sleep
@REM author: zsh
@REM date: 2023-02-14

:: �ر��������
@echo off

:: �����ӳٻ�������
setlocal EnableDelayedExpansion

:: for /F ѭ�������ļ���������; delimsָ���и��ַ�; tokensָ����ȡ�ڼ���
:: ��ȡ����
for /F "delims=: tokens=2" %%i in ('ipconfig ^| find "����"') do (
    if not "%%i" == " " (
        set gateway=%%i
    )
)
echo ����%gateway%

:: for /F ѭ�������ļ���������; delimsָ���и��ַ�; tokensָ����ȡ�ڼ���
:: ��ȡ���Ա���IP
for /F "delims=: tokens=2" %%i in ('ipconfig ^| find /i "ipv4"') do (
    set var=%%i
    if "%gateway:~0,11%" == "!var:~0,11!" (
        set ipaddress=!var!
    )
)
echo ������ַ%ipaddress%

:: ipǰ׺
set prefix=%gateway:~1,10%

:: ͨ�������ļ�
:: echo ping ^%%1 > nul ^2^>^&1 > temp/pingSubCommand%%i.bat
mkdir temp

:: for /L ������ʽѭ��һ����������(start,step,end)
for /L %%i in (2, 1, 254) do (
    set pingIP= %prefix%%%i
    :: �����������ļ�, �������ͬ�ļ���
    echo @echo off > temp\pingSubCommand%%i.bat
    echo ping !pingIP! ^> pingResult%%i.txt ^2^>^&1 >> temp\pingSubCommand%%i.bat
    start /B /D temp pingSubCommand%%i.bat
)

:: ����20s
echo �ȴ�20s
ping 9.1.1.1 -n 1 -w 20000 > nul

:: ɾ���ļ�
for /L %%i in (2, 1, 254) do (
    for /F %%j in ('type temp\pingResult%%i.txt ^| find /c "ʱ��"') do (
        if %%j NEQ 0 (
            echo %prefix%%%i ����
        )
    )
    type temp\pingResult%%i.txt >> pingResult.txt
)

del /Q temp
rd temp
pause