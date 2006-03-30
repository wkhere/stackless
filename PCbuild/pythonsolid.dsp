# Microsoft Developer Studio Project File - Name="pythonsolid" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** NICHT BEARBEITEN **

# TARGTYPE "Win32 (x86) Console Application" 0x0103
# TARGTYPE "Win32 (ALPHA) Console Application" 0x0603

CFG=pythonsolid - Win32 Alpha Debug
!MESSAGE Dies ist kein gültiges Makefile. Zum Erstellen dieses Projekts mit NMAKE
!MESSAGE verwenden Sie den Befehl "Makefile exportieren" und führen Sie den Befehl
!MESSAGE 
!MESSAGE NMAKE /f "pythonsolid.mak".
!MESSAGE 
!MESSAGE Sie können beim Ausführen von NMAKE eine Konfiguration angeben
!MESSAGE durch Definieren des Makros CFG in der Befehlszeile. Zum Beispiel:
!MESSAGE 
!MESSAGE NMAKE /f "pythonsolid.mak" CFG="pythonsolid - Win32 Alpha Debug"
!MESSAGE 
!MESSAGE Für die Konfiguration stehen zur Auswahl:
!MESSAGE 
!MESSAGE "pythonsolid - Win32 Release" (basierend auf  "Win32 (x86) Console Application")
!MESSAGE "pythonsolid - Win32 Debug" (basierend auf  "Win32 (x86) Console Application")
!MESSAGE "pythonsolid - Win32 Alpha Debug" (basierend auf  "Win32 (ALPHA) Console Application")
!MESSAGE "pythonsolid - Win32 Alpha Release" (basierend auf  "Win32 (ALPHA) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName "pythonsolid"
# PROP Scc_LocalPath ".."

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "."
# PROP Intermediate_Dir "x86-temp-release\pythonsolid"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
F90=df.exe
CPP=cl.exe
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MD /W3 /GX /Zi /O2 /I "..\Include" /I "..\PC" /I "..\Stackless" /I "..\Python" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /D "USE_DL_EXPORT" /YX /FD /c
RSC=rc.exe
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 largeint.lib kernel32.lib user32.lib advapi32.lib shell32.lib /nologo /base:"0x1d000000" /subsystem:console /debug /machine:I386 /nodefaultlib:"libc"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "."
# PROP Intermediate_Dir "x86-temp-debug\pythonsolid"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
F90=df.exe
CPP=cl.exe
# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /I "..\Include" /I "..\PC" /I "..\Stackless" /I "..\Python" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /D "USE_DL_EXPORT" /FR /YX /FD /c
RSC=rc.exe
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /i "..\Include" /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 largeint.lib kernel32.lib user32.lib advapi32.lib shell32.lib /nologo /base:"0x1d000000" /subsystem:console /debug /machine:I386 /nodefaultlib:"libc" /out:"./pythonsolid_d.exe" /pdbtype:sept
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "."
# PROP Intermediate_Dir "alpha-temp-debug\pythonsolid"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
CPP=cl.exe
# ADD BASE CPP /nologo /Gt0 /W3 /GX /Zi /Od /I "..\Include" /I "..\PC" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /FR /YX /FD /c
# ADD CPP /nologo /MDd /Gt0 /W3 /GX /Zi /Od /I "..\Include" /I "..\PC" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /FR /YX /FD /c
F90=df.exe
RSC=rc.exe
# ADD BASE RSC /l 0x409 /i "..\Include" /d "_DEBUG"
# ADD RSC /l 0x409 /i "..\Include" /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /debug /machine:ALPHA /out:"./pythonsolid_d.exe" /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib wsock32.lib /nologo /subsystem:console /debug /machine:ALPHA /out:"./pythonsolid_d.exe" /pdbtype:sept

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "."
# PROP Intermediate_Dir "alpha-temp-release\pythonsolid"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
CPP=cl.exe
# ADD BASE CPP /nologo /Gt0 /W3 /GX /Zi /O2 /I "..\Include" /I "..\PC" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MD /Gt0 /W3 /GX /O2 /I "..\Include" /I "..\PC" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
F90=df.exe
RSC=rc.exe
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /debug /machine:ALPHA
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib wsock32.lib /nologo /subsystem:console /debug /machine:ALPHA

!ENDIF 

# Begin Target

# Name "pythonsolid - Win32 Release"
# Name "pythonsolid - Win32 Debug"
# Name "pythonsolid - Win32 Alpha Debug"
# Name "pythonsolid - Win32 Alpha Release"
# Begin Source File

SOURCE=..\Modules\_codecsmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\_hotshot.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\_localemodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\_weakref.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\abstract.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\acceler.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\arraymodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\atomicobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\audioop.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\binascii.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\bitset.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\bltinmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\bufferobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\cellobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\ceval.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\cframeobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\changelog.txt
# End Source File
# Begin Source File

SOURCE=..\Stackless\channelobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\classobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\cmathmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\cobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\codecs.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\compile.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\complexobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\PC\config.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\cPickle.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\cStringIO.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\descrobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\dictobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\PC\dl_nt.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\dynload_win.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\errnomodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\errors.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\exceptions.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\fileobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\flextype.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\flextype.h
# End Source File
# Begin Source File

SOURCE=..\Objects\floatobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\frameobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\frozen.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\funcobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\future.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\gcmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\getargs.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\getbuildinfo.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\getcompiler.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\getcopyright.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\getmtime.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\getopt.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\PC\getpathp.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\getplatform.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\getversion.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\graminit.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\grammar1.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\imageop.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\import.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\PC\import_nt.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\importdl.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\intobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\iterobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\listnode.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\listobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\longobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\main.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\marshal.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\mathmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\md5c.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\md5module.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\metagrammar.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\methodobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\modsupport.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\moduleobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\PC\msvcrtmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\myreadline.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\mysnprintf.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\mystrtoul.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\newmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\node.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\object.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\operator.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\parser.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\parsetok.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\pcremodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\posixmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\PC\pycon.ico
# End Source File
# Begin Source File

SOURCE=..\Python\pyfpe.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\pypcre.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\pystate.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\python.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\PC\python_exe.rc
# End Source File
# Begin Source File

SOURCE=..\Python\pythonrun.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\rangeobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\readme.txt
# End Source File
# Begin Source File

SOURCE=..\Modules\regexmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\regexpr.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\rgbimgmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\rotormodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\schedulerobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\schedulerobject.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\scheduling.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\shamodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\signalmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\sliceobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\slp_platformselect.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\slp_transfer.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_api.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_ceval.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_debug.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_frame.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_impl.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_structs.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_sysmodule.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_tkinter.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_tstate.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_util.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\stackless_version.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\stacklesseval.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\stacklessmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\stringobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\stropmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\structmember.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\structmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\structseq.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\switch_ppc_macosx.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\switch_ppc_unix.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\switch_s390_unix.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\switch_sparc_sun_gcc.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\switch_x86_msvc.h
# End Source File
# Begin Source File

SOURCE=..\Stackless\switch_x86_unix.h
# End Source File
# Begin Source File

SOURCE=..\Python\symtable.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\sysmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Stackless\taskletobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\thread.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\threadmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\timemodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Parser\tokenizer.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Python\traceback.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\tupleobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\typeobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\unicodectype.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\unicodeobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Objects\weakrefobject.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\xreadlinesmodule.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\xxsubtype.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\Modules\yuvconvert.c

!IF  "$(CFG)" == "pythonsolid - Win32 Release"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Debug"

!ELSEIF  "$(CFG)" == "pythonsolid - Win32 Alpha Release"

!ENDIF 

# End Source File
# End Target
# End Project
