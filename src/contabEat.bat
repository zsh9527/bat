@REM description: create eat crontab task, 11:59
@REM author: zsh
@REM date: 2023-02-22

@echo off

echo %~dp0
schtasks /create /tn eat /tr %~dp0eat.bat /sc DAILY /st 11:59:00