<#
$Metadata = @{
	Title = "Get TrueCrypt Container"
	Filename = "Get-TrueCyptContainer.ps1"
	Description = "Get definitions from TrueCrypt configuratons"
	Tags = ""
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2014-01-08"
	LastEditDate = "2014-01-08"
	Url = ""
	Version = "0.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or 
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Get-TrueCryptContainer{

<#
.SYNOPSIS
    Get definitions from TrueCrypt configuratons.

.DESCRIPTION
	Get TrueCrypt container definitions from the config file, can check wether the container is mounted or not.

.PARAMETER Name
	Name or Key of the container.

.PARAMETER Mounted
	Return only mounted containers.

.PARAMETER All
	Get all available containers.
    
.EXAMPLE
	PS C:\> Get-TrueCypteContainer -All -Mountend

.EXAMPLE
	PS C:\> Get-TrueCypteContainer -Name "Private Container"
#>

    [CmdletBinding()]
    param(

        [Parameter(Mandatory=$false)]
		[String]
		$Name,       

		[Switch]
		$All,
        
        [Switch]
		$Mounted
	)
  
    #--------------------------------------------------#
    # main
    #--------------------------------------------------#
	
    if(-not ($All -or $Name)){
        throw "Provide at least one parameter for this function."
    }
    
    $MountedContainers = Get-PPConfiguration $PSconfigs.TrueCryptContainer.DataFile | %{$_.Content.MountedContainer}
    
    Get-PPConfiguration $PSconfigs.TrueCryptContainer.Filter | %{$_.Content.TrueCryptContainer} | %{
    
        $(if($All){        
            
            $_ | select Key, Name, @{L="Path";E={Get-Path (Resolve-Path $TrueCryptContainers.Path).Path}}, FavoriteDriveLetter
            
        }elseif($Name){
        
            $_ | where{$_.Name -like $Name -or $_.Key -like $Name} | select Key, Name, @{L="Path";E={Get-Path (Resolve-Path $TrueCryptContainers.Path).Path}}, FavoriteDriveLetter
        
        }) | %{
        
        
            if($Mounted){
            
                $TrueCryptContainer = $_
            
                $MountedContainer = $MountedContainers | where{$_.Name -eq $TrueCryptContainer.Name}
                
                if($MountedContainer){$_ | select Key, Name, Path, FavoriteDriveLetter, @{L="Drive";E={$MountedContainer.Drive}}}
                
            }else{
            
                $_
            } 
        }    
    }
}