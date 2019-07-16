FROM microsoft/windowsservercore
WORKDIR "C:\\"
COPY cake.exe config.ini "C:\\"
CMD cake.exe
EXPOSE 5000
