:: 启动指定目录下的jar程序
@echo off
cd /d "F:\scheduler"
for %%i in (*.jar) do (
    start "" "javaw" -jar "%%i"
)