# Auto-generated by EclipseNSIS Script Wizard
# 16.02.2011 14:21:40

!define APP_NAME "eXpandFramework"

Name "${APP_NAME}"

RequestExecutionLevel admin

# General Symbol Definitions
!define REGKEY "SOFTWARE\${APP_NAME}"
!ifndef VERSION
   !define VERSION 1.0
!endif
!ifndef DEVEXVERSION
   !define DEVEXVERSION "v14.2"
!endif
!define COMPANY eXpandFramework
!define URL http://www.expandframework.com

!define MicrosoftSDKsREGKEY "SOFTWARE\Microsoft\Microsoft SDKs\Windows"

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APP_NAME}"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\Installer\PageImage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\Installer\PageImage.bmp"

# Included files
!include Sections.nsh
!include MUI2.nsh

# Variables
Var StartMenuGroup
var gacutilPath

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\..\License.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile setup.exe
InstallDir $PROGRAMFILES\eXpandFramework
CRCCheck on
XPStyle on
ShowInstDetails show
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

VIProductVersion "${VERSION}.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName "${APP_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription ""
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright "� 2011"
ShowUninstDetails show
BrandingText "${APP_NAME} Install System v ${VERSION}"

# Installer sections
!macro CREATE_SMGROUP_SHORTCUT NAME PATH
    Push "${NAME}"
    Push "${PATH}"
    Call CreateSMGroupShortcut
!macroend

Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r /x Xpand.DesignExperience ..\..\Build\Installer\*
    call InstallProjectTemplates
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    !insertmacro CREATE_SMGROUP_SHORTCUT "Dll list" $INSTDIR\XpandDllList.txt
    !insertmacro CREATE_SMGROUP_SHORTCUT "Source" $INSTDIR\Source.zip
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END    
    
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
    
    # add To display an assembly in the Add Reference dialog box http://msdn.microsoft.com/en-us/library/wkze6zky.aspx
    #WriteRegStr HKLM "SOFTWARE\Microsoft\.NETFramework\v3.0\AssemblyFoldersEx\Xpand" "" "$INSTDIR\Xpand.DLL"
    
    #call DllsToGAC
		ExecWait '"$INSTDIR\Xpand.Dll\GACInstaller.exe Xpand"' $0
		ExecWait "$INSTDIR\Xpand.Dll\Xpand.ToolboxCreator.exe" $0
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

!macro SET_GACUTIL_PATH un
    Function ${un}SetGacutilPath
        ReadRegStr $0 HKLM "${MicrosoftSDKsREGKEY}" "CurrentInstallFolder"
        StrCpy $gacutilPath "$0Bin\NETFX 4.0 Tools\gacutil.exe"
        IfFileExists $gacutilPath +4 0
          StrCmp "${un}" "un." 0 +2
            MessageBox MB_OK "gacutil.exe not found! The DLLs can not be installed into the GAC."
            MessageBox MB_OK "gacutil.exe not found! The DLLs can not be uninstalled from the GAC."
    FunctionEnd
!macroend

!insertmacro SET_GACUTIL_PATH ""
!insertmacro SET_GACUTIL_PATH "un."

# Uninstaller sections
!macro DELETE_SMGROUP_SHORTCUT NAME
    Push "${NAME}"
    Call un.DeleteSMGroupShortcut
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
		ExecWait '"$INSTDIR\Xpand.Dll\GACInstaller.exe" -m UnInstall' $0
		ExecWait '"$INSTDIR\Xpand.Dll\Xpand.ToolboxCreator.exe" u' $0
    !insertmacro DELETE_SMGROUP_SHORTCUT "Dll list"
		!insertmacro DELETE_SMGROUP_SHORTCUT "Source"
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    # remove To display an assembly in the Add Reference dialog box http://msdn.microsoft.com/en-us/library/wkze6zky.aspx
    #DeleteRegKey HKLM "SOFTWARE\Microsoft\.NETFramework\v3.0\AssemblyFoldersEx\Xpand"
		
    #call un.DllsFromGAC
				
    call un.InstallProjectTemplates
    
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    #call SetGacutilPath
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    #call un.SetGacutilPath
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
		#'"$INSTDIR\someprogram.exe" some parameters'
		
FunctionEnd

# Installer Language Strings
# TODO Update the Language Strings with the appropriate translations.

LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"

;Function MakeFileList
;    Exch $R0 #path
;    Exch
;    Exch $R1 #filter
;    Exch
;    Exch 2
;    Exch $R2 #output file
;    Exch 2
;    Push $R3
;    Push $R4
;    Push $R5
;     ClearErrors
;     FindFirst $R3 $R4 "$R0\$R1"
;      FileOpen $R5 $R2 w
;     
;     Loop:
;     IfErrors Done
;      FileWrite $R5 "$R0\$R4$\r$\n"
;      FindNext $R3 $R4
;      Goto Loop
;     
;     Done:
;      FileClose $R5
;     FindClose $R3
;    Pop $R5
;    Pop $R4
;    Pop $R3
;    Pop $R2
;    Pop $R1
;    Pop $R0
;FunctionEnd

;Function DllsToGAC
;    IfFileExists $gacutilPath +3 0
;      StrCpy $0 "1"
;      Goto Ende
;      
;    # get all eXpand Dll's from the $INSTDIR and put into XpandDllList.txt 
;    Push "$INSTDIR\XpandDllList.txt" # output file
;    Push "*.dll" # filter
;    Push "$INSTDIR\Xpand.DLL" # folder to search in
;    Call MakeFileList
;    
;    # install all eXpand Dll's to the GAC 
;    Exec '"$gacutilPath" /il "$INSTDIR\XpandDllList.txt" /f'
;    
;    Ende:
;    StrCmp $0 "1" 0 +2
;    DetailPrint "install assamblies into the GAC failed"
;FunctionEnd

;Function un.DllsFromGAC
;    IfFileExists $gacutilPath +3 0
;      StrCpy $0 "1"
;      Goto Ende
;
;    CreateDirectory "$TEMP\${APP_NAME}"
;
;    StrCpy $3 "$TEMP\${APP_NAME}\getDlls.cmd"
;    Delete $3
;
;    StrCpy $1 "$TEMP\${APP_NAME}\tempDllList.txt"
;
;    FileOpen $0 "$3" w
;    # get all eXpand Dll's from the GAC and put into tempDllList.txt
;    FileWrite $0 '"$gacutilPath" /l | find /i "Xpand." > "$1"'
;    FileClose $0
;
;    #ExecWait '"$gacutilPath" /l | find /i "Xpand." > "$1"'
;    ExecWait "$3"
;
;
;    # uninstall all eXpand Dll's to the GAC
;    ExecWait '"$gacutilPath" /ul "$1" /f' $0
;
;    RMDir /r "$TEMP\${APP_NAME}"
;
;    Ende:
;    StrCmp $0 "1" 0 +2
;    DetailPrint "uninstall assamblies from the GAC failed"
;FunctionEnd
;
Function InstallProjectTemplatesFiles
    Push $R0
    Exch
    Pop $R0
	CreateDirectory "$R0ProjectTemplates\CSharp\DevExpress XAF"
    File "/oname=$R0ProjectTemplates\CSharp\DevExpress XAF\XpandFullSolutionCS.${DevExVersion}.zip" "..\..\Build\Installer\Xpand.DesignExperience\vs_templates\cs\XpandFullSolutionCS.${DevExVersion}.zip"
	CreateDirectory "$R0ProjectTemplates\VisualBasic\DevExpress XAF"
    File "/oname=$R0ProjectTemplates\VisualBasic\DevExpress XAF\XpandFullSolutionVB.${DevExVersion}.zip" "..\..\Build\Installer\Xpand.DesignExperience\vs_templates\vb\XpandFullSolutionVB.${DevExVersion}.zip"
    Pop $R0
FunctionEnd

Function un.InstallProjectTemplatesFiles
    Push $R0
    Exch
    Pop $R0
    Delete "$0ProjectTemplates\CSharp\DevExpress XAF\XpandFullSolutionCS.${DevExVersion}.zip"
    Delete "$0ProjectTemplates\VisualBasic\DevExpress XAF\XpandFullSolutionVB.${DevExVersion}.zip"
    Pop $R0
FunctionEnd

Function InstallProjectTemplates
    Push $0
    ReadRegStr $0 HKLM "Software\Microsoft\VisualStudio\9.0" "InstallDir"
    StrCmp $0 "" +4 0
    Push $0
    call InstallProjectTemplatesFiles
    WriteRegStr HKLM "${REGKEY}" "VS9Path" $0
        
    ReadRegStr $0 HKLM "Software\Microsoft\VisualStudio\10.0" "InstallDir"
    StrCmp $0 "" +4 0
    Push $0
    call InstallProjectTemplatesFiles
    WriteRegStr HKLM "${REGKEY}" "VS10Path" $0
	
	ReadRegStr $0 HKLM "Software\Microsoft\VisualStudio\11.0" "InstallDir"
    StrCmp $0 "" +4 0
    Push $0
    call InstallProjectTemplatesFiles
    WriteRegStr HKLM "${REGKEY}" "VS11Path" $0
	
	ReadRegStr $0 HKLM "Software\Microsoft\VisualStudio\12.0" "InstallDir"
    StrCmp $0 "" +4 0
    Push $0
    call InstallProjectTemplatesFiles
    WriteRegStr HKLM "${REGKEY}" "VS12Path" $0
	
	Exec  "$0devenv.exe /InstallVSTemplates"
    
	Pop $0
FunctionEnd

Function un.InstallProjectTemplates
    Push $0

    ReadRegStr $0 HKLM "${REGKEY}" VS9Path
    StrCmp $0 "" +3 0
    Push $0
    call un.InstallProjectTemplatesFiles
    
    ReadRegStr $0 HKLM "${REGKEY}" VS10Path
    StrCmp $0 "" +3 0
    Push $0
    call un.InstallProjectTemplatesFiles
    
    Pop $0
    
    DeleteRegValue HKLM "${REGKEY}" VS9Path
    DeleteRegValue HKLM "${REGKEY}" VS10Path
FunctionEnd

Function CreateSMGroupShortcut
    Exch $R0 ;PATH
    Exch
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$R1.lnk" $R0
no_smgroup:
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

Function un.DeleteSMGroupShortcut
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$R1.lnk"
no_smgroup:
    Pop $R2
    Pop $R1
FunctionEnd
