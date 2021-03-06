param(
	[string]$Version,
	[string]$Path,
	[switch]$Force,
	$Update,
	[switch]$Uninstall
)

#--------------------------------------------------#
# settings
#--------------------------------------------------#

$Configs = @{
	Url = "http://download.tuxfamily.org/notepadplus/6.5.3/npp.6.5.3.Installer.exe"
	# Path = $Path
    Path = "$(Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)\"
    # ConditionExclusion = "Get-Command `"notepad++`" -ErrorAction SilentlyContinue"
}
$Configs | ForEach-Object{

    try{

        $_.Result = $null
        if(-not $_.Path){$_.Path = $Path}
        $Config = $_

        #--------------------------------------------------#
        # add app
        #--------------------------------------------------#

        if(-not $Uninstall){

            #--------------------------------------------------#
            # check condition
            #--------------------------------------------------#

            if($_.ConditionExclusion){            
                $_.ConditionExclusionResult = $(Invoke-Expression $Config.ConditionExclusion -ErrorAction SilentlyContinue)        
            }    
            if(($_.ConditionExclusionResult -eq $null) -or $Force){
                    	
                #--------------------------------------------------#
                # download
                #--------------------------------------------------#

                $_.Downloads = $_.Url | ForEach-Object{
                    Get-File -Url $_ -Path $Config.Path
                }       			

                #--------------------------------------------------#
                # installation
                #--------------------------------------------------#
				
				$Directory = "C:\Program Files\MongoDB\"; if(-not (Test-Path -Path $Directory)){New-Item -Path $Directory -Type directory}
				
                $_.Downloads | ForEach-Object{
                    Start-Process -FilePath $(Join-Path $_.Path $_.Filename) -ArgumentList "/VERYSILENT /NORESTART" -Wait -NoNewWindow
					Start-Process -FilePath "msiexec" -ArgumentList "/i $(Join-Path $_.Path $_.Filename) /quiet /norestart" -Wait
                }
								
                $WorkingPath = (Get-Location).Path
                Set-Location "C:\Program Files\"
				$_.Downloads | ForEach-Object{
                    & 7za x $(Join-Path $_.Path $_.Filename) -y
                }
                Set-Location $WorkingPath
                
                Rename-Item -Path "C:\Program Files\mongodb-win32-x86_64-2008plus-2.4.9" -NewName "MongoDB" -Force
                		
                #--------------------------------------------------#
                # configuration
                #--------------------------------------------------#	

                $Executable = "C:\Program Files (x86)\PuTTY\putty.exe";if(Test-Path $Executable){Set-Content -Path (Join-Path $PSbin.Path "putty.bat") -Value "@echo off`nstart `"`" `"$Executable`" %*"}
				
				Set-EnvironmentVariableValue -Name "Path" -Value ";C:\Program Files (x86)\Notepad++\" -Target "Machine" -Add
                
                #--------------------------------------------------#
                # cleanup
                #--------------------------------------------------#

                $_.Downloads | ForEach-Object{
                    Remove-Item $(Join-Path $_.Path $_.Filename)
                }
                		
                #--------------------------------------------------#
                # finisher
                #--------------------------------------------------#
                		
                if($Update){$_.Result = "AppUpdated";$_
                }else{$_.Result = "AppInstalled";$_}
            		
            #--------------------------------------------------#
            # condition exclusion
            #--------------------------------------------------#
            		
            }else{
            	
                $_.Result = "ConditionExclusion";$_
            }

        #--------------------------------------------------#
        # remove app
        #--------------------------------------------------#
        	
        }else{

			Remove-EnvironmentVariableValue -Name Path -Value ";C:\Program Files\nodejs" -Target Machine
		
            if(Test-Path (Join-Path $PSbin.Path "putty.bat")){Remove-Item (Join-Path $PSbin.Path "putty.bat")}
            
            $Executable = "C:\Program Files (x86)\PuTTY\unins000.exe"; if(Test-Path $Executable){Start-Process -FilePath $Executable -ArgumentList "/VERYSILENT /NORESTART" -Wait -NoNewWindow}
            
			$Directory = "C:\Program Files\MongoDB\"; if(Test-Path $Directory){Remove-Item -Path $Directory -Force -Recurse}
			
            $_.Result = "AppUninstalled";$_
        }

    #--------------------------------------------------#
    # catch error
    #--------------------------------------------------#

    }catch{

        $Config.Result = "Error";$Config
    }
}