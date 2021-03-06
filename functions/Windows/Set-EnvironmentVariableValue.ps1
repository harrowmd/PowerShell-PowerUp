<#
$Metadata = @{
	Title = "Set Environment Variable Value"
	Filename = "Set-EnvironmentVariableValue.ps1"
	Description = ""
	Tags = "powershell, function, add, environment, vairable"
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2014-02-05"
	LastEditDate = "2014-02-23"
	Url = ""
	Version = "0.0.1"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or 
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Set-EnvironmentVariableValue{

<#
.SYNOPSIS
    Set value of an environment variable.

.DESCRIPTION
	Set value or add value if not already exists of an environment variable.

.PARAMETER Name
	Name of the variable.

.PARAMETER Value
	Value to set.
    
.PARAMETER Target
    Scope of the variable. Machine or User.
    
.PARAMETER Add
    Add value to existing variable content.

.EXAMPLE
	PS C:\> Set-EnvironmentVariableValue -Name Path -Value ";C:\bin" -Target Machine -Add

#>

    [CmdletBinding()]
    param(

		[Parameter(Mandatory=$true)]
		[String]
		$Name,
        
		[Parameter(Mandatory=$true)]
		[String]
		$Value, 
         
		[Parameter(Mandatory=$true)]
		[String]
		$Target,  

		[Switch]
		$Add  
	)  
  
    #--------------------------------------------------#
    # main
    #--------------------------------------------------#

    [Environment]::GetEnvironmentVariable($Name,$Target) | %{
                
        if(-not $_.Contains($Value) -and $Add){
            
            Write-Host "Adding value: $Value to variable: $Name"    
            $Value = ("$_" + $Value)        
            [Environment]::SetEnvironmentVariable($Name, $Value, $Target)
            Invoke-Expression "`$env:$Name = `"$Value`""
        
        }elseif(-not $Add){
        
            Write-Host "Set value: $Value on variable: $Name"
            [Environment]::SetEnvironmentVariable($Name,$Value,$Target)
            Invoke-Expression "`$env:$Name = `"$Value`""          
        }
    }     
}       