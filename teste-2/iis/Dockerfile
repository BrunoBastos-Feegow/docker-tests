FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Install-WindowsFeature Web-ASP; \
    Install-WindowsFeature Web-CGI; \
    Install-WindowsFeature Web-ISAPI-Ext; \
    Install-WindowsFeature Web-ISAPI-Filter; \
    Install-WindowsFeature Web-Includes; \
    Install-WindowsFeature Web-HTTP-Errors; \
    Install-WindowsFeature Web-Common-HTTP; \
    Install-WindowsFeature Web-Performance; \
    Install-WindowsFeature WAS; \
    Install-WindowsFeature Web-Mgmt-Service; \
    Import-module IISAdministration; \
    Import-Module ServerManager; Add-WindowsFeature Web-Scripting-Tools; \
    Import-Module WebAdministration; \
    New-ItemProperty -Path HKLM:\software\microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1 -Force; \
    Set-Service -Name wmsvc -StartupType automatic;

RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/asp
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/handlers
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/modules

#RUN Set-ItemProperty -Path 'IIS:\AppPools\DefaultAppPool' -Name 'processModel.loadUserProfile' -Value 'True'; \
#    Set-ItemProperty -Path 'IIS:\AppPools\DefaultAppPool' -Name 'processModel.setProfileEnvironment' -Value 'True' ;

RUN net user iisadmin "Password~1234" /ADD; \
    net localgroup administrators iisadmin /add;

#RUN md c:/inetpub/wwwroot/feegowclinic-v7
RUN icacls "C:\inetpub\wwwroot" --% /grant "everyone:(OI)(CI)F /T"
#RUN icacls "C:\inetpub\wwwroot\*" --% /grant "everyone:(OI)(CI)F /T"

RUN md c:/msi;
COPY msi c:/msi
RUN Start-Process 'c:/msi/rewrite_amd64_en-US.msi' '/qn' -PassThru | Wait-Process;
RUN Start-Process 'c:/msi/msodbcsql_x64.msi' '/qn' -PassThru | Wait-Process;

EXPOSE 880

#RUN Remove-Website -Name 'Default Web Site'; \
#    md c:\mywebsite; \
#    New-IISSite -Name "mywebsite" \
#                -PhysicalPath 'c:\mywebsite' \
#                -BindingInformation "*:8000:";

RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/asp
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/handlers
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/modules

#RUN Add-OdbcDsn -Name "mywebsite" \
#                -DriverName "\"ODBC Driver 13 For SQL Server\"" \
#                -DsnType "System" \
#                -SetPropertyValue @("\"Server=XXXX.us-east-2.rds.amazonaws.com\"", "\"Trusted_Connection=No\"");

