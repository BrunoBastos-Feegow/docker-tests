FROM mcr.microsoft.com/windows/servercore/iis

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN Install-WindowsFeature -Name Web-ASP, Web-CGI, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Includes, Web-HTTP-Errors, Web-Common-HTTP, Web-Performance, WAS;
RUN Import-module IISAdministration;

RUN md c:/msi;
COPY msi/ c:/msi/
RUN Start-Process 'c:/msi/rewrite_amd64_en-US.msi' '/qn' -PassThru | Wait-Process;
RUN Start-Process 'c:/msi/mysql-connector-odbc-8.0.32-winx64.msi' '/qn' -PassThru | Wait-Process;

EXPOSE 80

#RUN Remove-Item -Recurse C:\inetpub\wwwroot\*
#RUN Remove-Website -Name 'Default Web Site';
#RUN New-IISSite -Name "Default Web Site" -PhysicalPath 'c:\inetpub\wwwroot' -BindingInformation "*:80:";

RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/asp
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/handlers
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/modules

#RUN Add-OdbcDsn -Name "feegowclinic-v7" -DriverName "\"ODBC Driver 8 ANSI Driver\"" -DsnType "System" -SetPropertyValue @("\"Server=localhost\"", "\"Trusted_Connection=No\"");
#WORKDIR /inetpub/wwwroot/feegowclinic-v7/
#COPY feegowclinic-v7/ .