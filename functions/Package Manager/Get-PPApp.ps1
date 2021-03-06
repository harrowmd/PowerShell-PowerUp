<#
$Metadata = @{
	Title = "Get PowerShell PowerUp App"
	Filename = "Get-PPApp.ps1"
	Description = ""
	Tags = "powershell, profile, get, apps"
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2013-10-25"
	LastEditDate = "2013-10-25"
	Url = ""
	Version = "1.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or 
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Get-PPApp{

<#
.SYNOPSIS
    Get available PowerShell PowerUp apps.

.DESCRIPTION
	Get available PowerShell PowerUp apps.

.PARAMETER  Name
	The description of the ParameterA parameter.
    
.EXAMPLE
	PS C:\> Get-PPApp

#>

	param(
        [Parameter(Mandatory=$false)]
		[String]
		$Name,
        
        [switch]
        $Installed
	)
    
    $InstalledApps = Get-PPConfiguration -Filter $PSconfigs.App.DataFile -Path $PSconfigs.Path | %{$_.Content.App}
    
    $(if($Name){
    
        Get-PPConfiguration -Filter $PSconfigs.App.Filter -Path $PSlib.Path | %{$_.Content.App | where{$_.Name -match $Name}}
        
    }else{
    
        Get-PPConfiguration $PSconfigs.App.Filter -Path $PSlib.Path | %{$_.Content.App}
        
    }) | %{
    
        if($Installed){
                
            $Name = $_.Name
            $Version = $_.Version
            
            $InstalledApps | where{($_.Name -eq $Name) -and ($_.Version -eq $Version)}
                  
        }else{
        
            $_
        }
    }
}