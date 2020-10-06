; Author: Brett Riley
; Version: 3.2
; Date: 19/10/2012
;
; <kym>
; OPCODE list (taken from https://www.autohotkey.com/docs/misc/SendMessageList.htm):
; https://www.autohotkey.com/docs/commands/PostMessage.htm
;
;WM_CLOSE := 0x10 close window
;WM_SYSCOMMAND := 0x112 Perform a systemcall
;SC_KEYMENU:= 0xF100 Retrieves the window menu as a result of a keystroke.
;</kym>

strVersion := 4.0
strExtractSystem = DWNRDHBAS0C ; Clone (DWNRDHBAS1C) or Prod (DWNRDHBAS0C)

if 0 < 1 ; If run with no paramaters 
{
	
if (strExtractSystem = "DWNRDHBAS0C")
{
	run, C:\Automation\Jade635\bin\jade.exe server=multiUser appServer=155.205.120.111 appServerPort=6091 schema=JadeMonitorSchema app=RPSManager ; PRODUCTION
}
Else
{
	run, C:\Automation\Jade635\bin\jade.exe server=multiUser appServer=155.205.120.121 appServerPort=6035 schema=JadeMonitorSchema app=RPSManager ; CLONE
}

Sleep, 4000

IfWinNotExist,Jade RPS Manager ; should now be If !WinExist("Jade RPS Manager") as per https://www.autohotkey.com/docs/commands/WinExist.htm /kym
{
	Sleep, 60000
	IfWinNotExist,Jade RPS Manager ;check again after a period of time if Jade RPS Manager exists
	{
		; Window still doesn't exist, error out
		; %comspec% is an env which points to cmd.exe, this executes a VBS script with an arg string
		Run, %comspec% /c "c:\Automation\SendEmail.vbs "PCIS RPS Central extract ERROR" "ERR 1: Process timed out while waiting for program to start.<br/>Automation script version: %strVersion%""		
		SendMessage, 0x10, , , , Jade RPS Manager ; close the program
		Sleep, 5000
		Process, Close, jade.exe		
		Return
	}
}

SendMessage, 0x112, 0xF100, , , Jade RPS Manager ; 0x112 is WM_SYSCOMMAND, 0xF100 is SC_KEYMENU - essentially calling the window menu in Jade RPS Manager /kym
ControlSend,,{right}{right}{down}{enter}, Jade RPS Manager ; with menu opened we send the specified keys

Sleep, 1000

; Send keys to individule controls of windows
ClassName = Jade:Edit
winName1 = Output 			 ;child win name inside specimen main window
winName2 = Multiple Extracts ;child win name inside specimen main window
winName3 = &OK
appName = Data Extract 		 ;main window with multiple child windows
nWinCount = 0
hwndOkButton := ""

WinGet, conList, ControlListHwnd, % appName 
Loop, Parse, conList, `n 
{ 
    curHwnd := A_Loopfield 
    WinGetTitle, curWin, ahk_id %curHwnd% 

	if (curWin = winName1) || (curWin = winName2)
	{
		WinGet, conList, ControlListHwnd, ahk_id %curHwnd% 		
		Loop, Parse, conList, `n ; Find all Jade:Edit fields
		{ 
			curHwnd := A_Loopfield
			WinGetClass, curWin, ahk_id %curHwnd% 
			if (curWin = ClassName) 
			{
				nWinCount++
				if (nWinCount == 1) ; Number of workers
					ControlSetText , , 30,  ahk_id %curHwnd%
				else if (nWinCount == 2) ; Server Name
					ControlSetText , , PCIS_RPS_PRESTAGING,  ahk_id %curHwnd%
				else if (nWinCount == 3) ; RDB Path
					ControlSetText , , Z:\,  ahk_id %curHwnd%
				else if (nWinCount == 4) ; Script file path
					ControlSetText , , C:/BR,  ahk_id %curHwnd%
				else if (nWinCount == 5) ; Data files path
					ControlSetText , , C:/BR,  ahk_id %curHwnd%						
			}
		}
	}

	if (curWin = winName3)
	{
		hwndOkButton := curHwnd
	}

} 

ControlFocus, , ahk_id %hwndOkButton% 			; Select OK Button
ControlSend,,{enter}, ahk_id %hwndOkButton% 	; Hit Ok button

Sleep, 10000

; Get the HWnd to the extract progress window
WinGet, OutputVar, ID, Data Extract Progress

; Here the script needs to wait until the extract is complete. 
; When the extract finishes the Data Extract Progress dialog will close, if it has not
; closed after 2 hours we can assume something has gone wrong and to error out.
loop
{
	; Wait until the Print dialog has gone, check every 1 min
	; when it has the copy has finished
	IfWinNotExist, ahk_id %OutputVar% ;Data Extract Progress
	{
		Break
	}

	Sleep, 60000 ; sleep every minute
	if a_index > 120 ; Close after 2 hours
	{
		Run, %comspec% /c "c:\Automation\SendEmail.vbs "PCIS RPS Central extract ERROR" "ERR 5: Process timed out while waiting for extract to finsih.""
		SendMessage, 0x10, , , , Jade RPS Manager ; close the program
		Sleep, 5000
		Process, Close, jade.exe		
		return		
	}
}
; --------------------------------- FINISH RPS ----------------------------------------

Sleep, 500
SendMessage, 0x10, , , , Jade RPS Manager ; close the program
Sleep, 5000
Process, Close, jade.exe

; Send success email
Run, %comspec% /c "c:\Automation\SendEmail.vbs "PCIS Central RPS extract SUCCESS" "Central PCIS Production RPS extract complete.<br/>Automation script version: %strVersion%""
; --------------------------------- START SQL ----------------------------------------

Run, %comspec% /c "net start RPSExtractSQLService" ; Success, so start the next part of the script that requires network privliges

Return
}

; ----------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------
; SQL Portion
; ----------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------


if 1 = /SQL ; If run with SQL flag
{

; Check if the extract files exist
IfNotExist, \\%strExtractSystem%\c$\BR\*.sql
{
	Run, %comspec% /c "c:\Automation\SendEmail.vbs "PCIS Central extract ERROR" "ERR 6a: \\%strExtractSystem%\c$\BR directory is empty.<br/>Automation script version: %strVersion%""
	return		
}

; --------------------------------- MOVE FILES - OLD ----------------------------------------
/*
; FileMove, \\%strExtractSystem%\c$\BR\*.*, \\dwnrdhbas1a\k$\temp\PCIS_RPS\*.*, 1
RunWait, %comspec% /c "robocopy \\dwnrdhbas0c\c$\BR K:\temp\PCIS_RPS *.* /MOV /Z /R:50 /W:5" ; Move files, Resumable, 50 attempts, 5 sec delay
if ErrorLevel <> 0 ; A number of files could not be moved
{
	Run, %comspec% /c "c:\Automation\SendEmail.vbs "PCIS Central extract ERROR" "ERR 6: Copy of \\%strExtractSystem%\c$\BR to k:\temp\PCIS_RPS FAILED.<br/>Automation script version: %strVersion%""
	return		
}
*/

; --------------------------------- MAP SERVER FOLDER ----------------------------------------
RunWait, % comspec " /c ""C:\Automation\MS SQL 80 Tools\Binn\osql.exe"" -S dwnrdhbas1a\DW,4790 -U RPS -P rps -i c:\Automation\MapNetwork.sql",, Hide ; Map the folder on the server ready to import data directly

Sleep, 5000

FileGetTime, OutputVar, Z:\bulkinsert.sql, M
StringLeft, OutputVar, OutputVar, 8
StringLeft, OutputVarNow, A_Now, 8

; If the bulkload.sql file is NOT current, then dont continue
if (OutputVar != OutputVarNow)
{
	Run, %comspec% /c "c:\Automation\SendEmail.vbs "PCIS Central extract ERROR" "ERR 7: BulkLoad.sql file is not current. Older data will not be loaded.<br/>Automation script version: %strVersion%""
	return			
}

; --------------------------------- FINISH FILES----------------------------------

; --------------------------------- MS SQL PRESTAGING LOAD-----------------------------

RunWait, % comspec " /c ""C:\Automation\MS SQL 80 Tools\Binn\osql.exe"" -S dwnrdhbas1a\DW,4790 -U RPS -P rps -i Z:\drop_and_create_tables.sql",, Hide ; Connect to the SQL server via console and recreate all tables
;bas1a RunWait, % comspec " /c ""C:\Program Files\Microsoft SQL Server\80\Tools\Binn\osql.exe"" -S dwnrdhbas1a\DW,4790 -U RPS -P rps -i \\dwnrdhbas1a\k$\temp\PCIS_RPS\drop_and_create_tables.sql",, Hide ; Connect to the SQL server via console and recreate all tables
Sleep, 2000
RunWait, % comspec " /c ""C:\Automation\MS SQL 80 Tools\Binn\osql.exe"" -S dwnrdhbas1a\DW,4790 -U RPS -P rps -i Z:\bulkinsert.sql",, Hide ; Now load all of the data
;bas1a RunWait, % comspec " /c ""C:\Program Files\Microsoft SQL Server\80\Tools\Binn\osql.exe"" -S dwnrdhbas1a\DW,4790 -U RPS -P rps -i \\dwnrdhbas1a\k$\temp\PCIS_RPS\bulkinsert.sql",, Hide ; Now load all of the data

Sleep, 10000

; Now delete all the temp extract files to free space
FileDelete Z:\*.tbl ; All data

Sleep, 10000

FileDelete Z:\*.fmt ; All definitions

; --------------------------------- FINISH MS SQL PRESTAGING LOAD----------------------

; Unmap network
RunWait, % comspec " /c ""C:\Automation\MS SQL 80 Tools\Binn\osql.exe"" -S dwnrdhbas1a\DW,4790 -U RPS -P rps -i c:\Automation\UnmapNetwork.sql",, Hide ; Remove the map to folder on the server 

; Send success email
Run, %comspec% /c "c:\Automation\SendEmail.vbs "PCIS Central RPS preload into MS SQL SUCCESS" "Central PCIS Production RPS data preload complete.<br/>Automation script version: %strVersion%""

; --------------------------------- FINISH SQL ----------------------------------------

; --------------------------------- DATASTAGE LOAD --------------------------------------

; Remotely start the datastage load on DHDRHBAST001 by running a remote command using PSExec.
run, %comspec% /c "c:\automation\psexec.exe -u PROD\svc_doh_dwta -p FR29uwruSaCHa5uf7SUw \\DHDRHBAST001 cmd.exe /c C:\IBM\InformationServer\Clients\Classic\dsjob.exe -server dhdrhbast001 -user svc_doh_dwta -password FR29uwruSaCHa5uf7SUw -domain NONE -run HEALTH_SERVICES Master_Load_Controller"

Return
}
; --------------------------------- FINISH DATASTAGE LOAD -------------------------------




############################
import win32api, win32con, win32gui, win32ui, win32service, os, time, subprocess
#https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes?redirectedfrom=MSDN
#https://stackoverflow.com/questions/12996985/send-some-keys-to-inactive-window-with-python
#https://stackoverflow.com/questions/21917965/send-keys-to-a-inactive-window-in-python
#http://timgolden.me.uk/pywin32-docs/win32api.html
import win32api, win32con, win32gui, win32ui, win32service, os, time
from ctypes import *
from pywinauto.application import Application
app = Application(backend="uia").start("E:\\nthDcareR\\server\\c_bin\\jade.exe path=E:\\nthDcareR\\Server\\c_system ini=E:\\nthDcareR\\Server\\c_bin\\nthDcareR.ini server=multiuser schema=JadeMonitorSchema  appServer=10.2.66.203  app=RPSManager")
while not app.windows():
    time.sleep(1)
time.sleep(3)
msg=("bajscbakcb")
def L337():
    a = app.windows()
    return (list(a))
b = (str(L337()[0]))
b = b.replace('hwndwrapper.DialogWrapper - ', '')
b = b.replace("uiawrapper.UIAWrapper - '", '')
b = b.replace("', Dialog", '')
b = b.replace(', Jade:form', '')

dlgHandle = win32gui.FindWindow (None, b)
print(win32gui.GetWindowText(dlgHandle))
app.window(title=b).print_control_identifiers()
secwin = win32gui.GetDlgItem(dlgHandle, int('18') )
win32api.SendMessage(dlgHandle, win32con.WM_SYSCOMMAND, win32con.SC_KEYMENU,0)
time.sleep(0.5)
#win32gui.SendMessage(secwin, win32con.WM_CHAR,  win32con.VK_MENU,0)
time.sleep(0.5)
count = win32gui.GetMenuItemCount(dlgHandle)
print(count)
#win32gui.SendMessage(dlgHandle, win32con.MN_GETHMENU,0,0)
#win32api.SendMessage(secwin, win32con.MN_GETHMENU, 0,0)
win32api.PostMessage(secwin, win32con.WM_KEYDOWN, win32con.VK_MENU,0)
#win32api.PostMessage(secwin, win32con.WM_KEYUP, win32con.VK_MENU,0)
win32api.PostMessage(secwin, win32con.WM_KEYDOWN, win32con.VK_RIGHT,0)
win32api.PostMessage(secwin, win32con.WM_KEYUP, win32con.VK_RIGHT,0)
win32api.PostMessage(secwin, win32con.WM_KEYDOWN, win32con.VK_DOWN,0)
win32api.PostMessage(secwin, win32con.WM_KEYUP, win32con.VK_DOWN,0)
win32api.PostMessage(secwin, win32con.WM_KEYDOWN, win32con.VK_DOWN,0)
win32api.PostMessage(secwin, win32con.WM_KEYUP, win32con.VK_DOWN,0)
win32api.PostMessage(secwin, win32con.WM_KEYDOWN, win32con.VK_RETURN,0)
win32api.PostMessage(secwin, win32con.WM_KEYUP, win32con.VK_RETURN,0)
#win32api.sendMessage(secwin, win32con.WM_CHAR, win32con.VK_RIGHT,0) #ord('r') MN_GETHMENU 
time.sleep(0.5)
#win32gui.SendMessage(secwin, win32con.WM_SETTEXT, 0, win32con.VK_MENU )




#win32api.SendMessage(dlgHandle, win32con.WM_KEYDOWN, win32con.VK_RETURN, 0)
#win32api.SendMessage(dlgHandle, win32con.WM_KEYUP, win32con.VK_RETURN, 0)
#win32api.SendMessage(dlgHandle, win32con.WM_SYSCOMMAND, win32con.SC_KEYMENU,0)
#time.sleep(0.5)
#win32api.SendMessage(dlgHandle, win32con.WM_KEYDOWN, win32con.VK_RETURN, 0)
#win32api.SendMessage(dlgHandle, win32con.WM_CHAR, win32con.WM_KEYDOWN, 0)
#win32gui.SendMessage(dlgHandle, win32con.WM_KEYDOWN, 0, 0)
#win32gui.SendMessage(dlgHandle, win32con.WM_KEYDOWN, 0, 0)
#win32gui.SendMessage(dlgHandle, win32con.WM_KEYDOWN, 0, 0)
#win32api.SendMessage(dlgHandle, win32con.WM_SYSCOMMAND, win32con.VK_RIGHT,0)
#win32api.SendMessage(dlgHandle, win32con.WM_KEYUP, win32con.VK_RIGHT,0)
#win32api.SendMessage(dlgHandle, win32con.WM_KEYDOWN, win32con.VK_DOWN,0)
#win32api.SendMessage(dlgHandle, win32con.WM_KEYDOWN, win32con.VK_DOWN,0)
#win32api.SendMessage(dlgHandle, win32con.WM_KEYDOWN, win32con.VK_RETURN,0)

#win32api.SendMessage(0x112, 0xF100, dlgHandle)
#win32gui.PostMessage(dlgHandle,win32con.WM_CLOSE,0,0)



