@REM description: ping 当前网段所有IP, 结果输出到pingResult.txt, ping 9.1.1.1 方式模拟sleep
@REM author: zsh
@REM date: 2023-02-14

:: 关闭命令回显
@echo off

:: 开启延迟环境变量
setlocal EnableDelayedExpansion

:: for /F 循环处理文件或输出结果; delims指定切割字符; tokens指定提取第几列
:: 获取网关
for /F "delims=: tokens=2" %%i in ('ipconfig ^| find "网关"') do (
    if not "%%i" == " " (
        set gateway=%%i
    )
)
echo 网关%gateway%

:: for /F 循环处理文件或输出结果; delims指定切割字符; tokens指定提取第几列
:: 获取电脑本机IP
for /F "delims=: tokens=2" %%i in ('ipconfig ^| find /i "ipv4"') do (
    set var=%%i
    if "%gateway:~0,11%" == "!var:~0,11!" (
        set ipaddress=!var!
    )
)
echo 内网地址%ipaddress%

:: ip前缀
set prefix=%gateway:~1,10%

:: 通用命令文件
:: echo ping ^%%1 > nul ^2^>^&1 > temp/pingSubCommand%%i.bat
mkdir temp

:: for /L 增量形式循环一个数字序列(start,step,end)
for /L %%i in (2, 1, 254) do (
    set pingIP= %prefix%%%i
    :: 生成子命令文件, 输出到不同文件中
    echo @echo off > temp\pingSubCommand%%i.bat
    echo ping !pingIP! ^> pingResult%%i.txt ^2^>^&1 >> temp\pingSubCommand%%i.bat
    start /B /D temp pingSubCommand%%i.bat
)

:: 休眠20s
echo 等待20s
ping 9.1.1.1 -n 1 -w 20000 > nul

:: 删除文件
for /L %%i in (2, 1, 254) do (
    for /F %%j in ('type temp\pingResult%%i.txt ^| find /c "时间"') do (
        if %%j NEQ 0 (
            echo %prefix%%%i 在线
        )
    )
    type temp\pingResult%%i.txt >> pingResult.txt
)

del /Q temp
rd temp
pause