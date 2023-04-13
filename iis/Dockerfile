FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Install-WindowsFeature Web-ASP; \
    Install-WindowsFeature Web-CGI; \
    Install-WindowsFeature Web-ISAPI-Filter; \
    Install-WindowsFeature Web-Includes; \
    Install-WindowsFeature Web-Mgmt-Service; \
    Install-WindowsFeature WAS; \
    Import-module IISAdministration; \
    Import-Module ServerManager; Add-WindowsFeature Web-Scripting-Tools; \
    Import-Module WebAdministration; \
    New-ItemProperty -Path HKLM:\software\microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1 -Force; \
    Set-Service -Name wmsvc -StartupType automatic; \
    Get-IISConfigSection -SectionPath system.webServer/defaultDocument | Get-IISConfigCollection -CollectionName files | New-IISConfigCollectionElement -ConfigAttribute @{'Value' = 'index.asp'} "

#enable client side debugging, parent paths etc
RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/asp /appAllowDebugging:true /commit:apphost
RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/asp /appAllowClientDebug:true /commit:apphost
RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/asp /enableParentPaths:true /commit:apphost
RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/asp /scriptErrorSentToBrowser:true /commit:apphost
RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/httpErrors /errorMode:Detailed /commit:apphost

RUN net user iisadmin "Password~1234" /ADD; \
    net localgroup administrators iisadmin /add;

RUN Remove-Item 'C:\inetpub\wwwroot*' -Recurse -Force
RUN md c:/inetpub/wwwroot
RUN icacls C:\inetpub\wwwroot /grant everyone:'(OI)(CI)F' /T

RUN md c:/msi;
COPY msi c:/msi

RUN Start-Process "msiexec.exe" -ArgumentList '/I c:\msi\rewrite_amd64_en-US.msi /quiet' -wait -nonewwindow
RUN Start-Process -FilePath 'c:\msi\VC_redist.x64.exe' -ArgumentList '/quiet' -wait -nonewwindow
RUN Start-Process "msiexec.exe" -ArgumentList '/I c:\msi\mysql-connector-odbc-8.0.32-winx64.msi /quiet' -wait -nonewwindow

RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/asp
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/handlers
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/modules

#add index.asp to the list of default documents
RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/defaultDocument /enabled:true /commit:apphost

RUN Add-OdbcDsn -Name "feegow_odbc_dsn" \
                -DriverName "\"MySQL ODBC 8.0 ANSI Driver\"" \
                -DsnType "System" \
                -SetPropertyValue @("\"Server=localhost\"", "\"Trusted_Connection=No\"");

# Copy the setenv.vbs script
COPY setenv.vbs /setenv.vbs

# Set the ENTRYPOINT to start IIS and keep it running
ENTRYPOINT ["cmd", "/c", "cscript.exe", "//B", "//Nologo", "setenv.vbs", "&", "powershell", "-Command", "Start-Service W3SVC;", "while ($true) { Start-Sleep -Seconds 3600 }"]

# Copy web.config to the root of the site
COPY web.config /inetpub/wwwroot/web.config