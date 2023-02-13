FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#RUN choco install -y php --version=7.4 --package-parameters='"/ThreadSafe ""/InstallDir:C:\PHP"""'

RUN Install-WindowsFeature Web-ASP; \
    Install-WindowsFeature Web-CGI; \
#    Install-WindowsFeature Web-ISAPI-Ext; \
    Install-WindowsFeature Web-ISAPI-Filter; \
    Install-WindowsFeature Web-Includes; \
#    Install-WindowsFeature Web-HTTP-Errors; \
#    Install-WindowsFeature Web-Common-HTTP; \
    Install-WindowsFeature Web-Mgmt-Service; \
#    Install-WindowsFeature Web-Performance; \
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
#RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.web/customErrors /mode:Off /commit:apphost
#RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.web/compilation /debug:true /commit:apphost

#add index.asp to the list of default documents
RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/defaultDocument /enabled:true /commit:apphost
#RUN & c:\windows\system32\inetsrv\appcmd.exe set config /section:system.webServer/defaultDocument/files .[value='index.asp'].enabled:true /commit:apphost


RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/asp
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/handlers
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/modules

#RUN Set-ItemProperty -Path 'IIS:\AppPools\DefaultAppPool' -Name 'processModel.loadUserProfile' -Value 'True'; \
#    Set-ItemProperty -Path 'IIS:\AppPools\DefaultAppPool' -Name 'processModel.setProfileEnvironment' -Value 'True' ;

RUN net user iisadmin "Password~1234" /ADD; \
    net localgroup administrators iisadmin /add;

#RUN md c:/inetpub/wwwroot/feegowclinic-v7
#remove Default Web Site
#RUN md c:\inetpub\wwwroot\feegowclinic-v7; \
#    New-IISSite -Name "feegowclinic-v7" -PhysicalPath 'c:\inetpub\wwwroot\feegowclinic-v7' -BindingInformation "*:880:"; \
#    New-WebVirtualDirectory -Site 'feegowclinic-v7' -Name "feegowclinic-v7" -PhysicalPath "C:\inetpub\wwwroot\feegowclinic-v7";

RUN Remove-Item 'C:\inetpub\wwwroot*' -Recurse -Force
RUN icacls "C:/inetpub/wwwroot" --% /grant "everyone:(OI)(CI)F /T"

RUN md c:/feegow-api
RUN icacls "c:/feegow-api" --% /grant "everyone:(OI)(CI)F /T"

RUN md c:/msi;
COPY msi c:/msi

RUN md c:/xampp;
COPY ../php/xampp c:/xampp
#RUN Start-Process 'c:/msi/rewrite_amd64_en-US.msi' '/qn' -PassThru | Wait-Process;
#RUN ["cmd", "/S", "/C", "c:\\windows\\syswow64\\msiexec", "/i", "c:\\msi\\mysql-connector-odbc-8.0.32-winx64.msi", "IACCEPTMSODBCSQLLICENSETERMS=YES", "ADDLOCAL=ALL", "/qn"]
RUN Start-Process "msiexec.exe" -ArgumentList '/I c:\msi\rewrite_amd64_en-US.msi /quiet' -wait -nonewwindow
RUN Start-Process -FilePath 'c:\msi\VC_redist.x64.exe' -ArgumentList '/quiet' -wait -nonewwindow
RUN Start-Process "msiexec.exe" -ArgumentList '/I c:\msi\mysql-connector-odbc-8.0.32-winx64.msi /quiet' -wait -nonewwindow

#RUN Remove-Website -Name 'Default Web Site'; \
#    md c:\mywebsite; \
#    New-IISSite -Name "mywebsite" \
#                -PhysicalPath 'c:\mywebsite' \
#                -BindingInformation "*:8000:";

RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/asp
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/handlers
RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/modules

RUN Add-OdbcDsn -Name "mywebsite" \
                -DriverName "\"MySQL ODBC 8.0 ANSI Driver\"" \
                -DsnType "System" \
                -SetPropertyValue @("\"Server=localhost\"", "\"Trusted_Connection=No\"");

RUN setx FC_MYSQL_HOST "1.1.1.3" -M; \
    setx FC_MYSQL_USER root -M; \
#    setx FC_MYSQL_PASSWORD "" -M; \
    setx FC_MASTER 123456 -M; \
    setx FC_MYSQL_DATABASE cliniccentral -M; \
    setx FC_MYSQL_DRIVER 'MySQL ODBC 8.0 ANSI Driver' -M; \
    setx FC_PWD_SALT F33g0W_Pwd4_ -M; \
#    setx FC_SRC_PATH 'C:/inetpub/wwwroot' -M; \
    setx FC_APP_ENV local -M;

EXPOSE 880