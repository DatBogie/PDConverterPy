Set oWS = WScript.CreateObject("WScript.Shell") 
sLinkFile = oWS.ExpandEnvironmentStrings("%APPDATA%\Microsoft\Windows\Start Menu\Programs\PDConverter.lnk")
Set oLink = oWS.CreateShortcut(sLinkFile)
oLink.TargetPath = oWS.ExpandEnvironmentStrings("%LOCALAPPDATA%\PDConverter\PDConverter.exe")
oLink.Save
