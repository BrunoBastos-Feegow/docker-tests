Dim WshShell, EnvVars, EnvVar
Set WshShell = CreateObject("WScript.Shell")

Set EnvVars = WshShell.Environment("Process")
For Each EnvVar In EnvVars
    WshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\" & Split(EnvVar, "=")(0), Split(EnvVar, "=")(1), "REG_SZ"
Next
