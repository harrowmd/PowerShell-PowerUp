<#
$Metadata = @{
    Title = "Report Filesystem Permissions"
	Filename = "Report-FileSystemPermissions.ps1"
	Description = ""
	Tags = ""powershell, sharepoint, function, report"
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2013-07-11"
	LastEditDate = "2013-07-11"
	Version = "1.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or 
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Report-FileSystemPermissions{

<#

.SYNOPSIS
    Report permissions on filesystem directories.

.DESCRIPTION
	Report permissions on filesystem directories.

.PARAMETER  Path
	Path of the directory to report
    
.PARAMETER  Levels
	Levels of subdirectories to report

.EXAMPLE
	PS C:\> Report-SPSecurableObjectPermissions -Path "D:\Data" -Levels 3

#>

    param(
        [parameter(Mandatory=$true)]
        [String]$Path, 
        
        [parameter(Mandatory=$true)]
        [int]$Levels
    )



    #--------------------------------------------------#
    # main
    #--------------------------------------------------#

    $FileSystemPermissionReport = @()

    $FSfolders = Get-ChildItemRecurse -Path $Path -Levels $Levels -OnlyDirectories

    foreach ($FSfolder in $FSfolders)
    {

        Write-Progress -Activity "Anlayse access rights" -status $FSfolder.FullName -percentComplete ([int]([array]::IndexOf($FSfolders, $FSfolder)/$FSfolders.Count*100))
        
        # read access rights
        $Acls = Get-Acl -Path $FSfolder.Fullname

        foreach($Acl in $Acls.Access){

            if($Acl.IsInherited -eq $false){
                
                $Member = $Acl.IdentityReference  -replace ".*?\\","" 
        
                $FileSystemPermissionReport += New-ObjectSPReportItem -Name $FSfolder.Name -Url $FSfolder.FullName -Member $Member -Permission $Acl.FileSystemRights   -Type "Directory"

            }else{
                break
            }
        }
    }

    return $FileSystemPermissionReport
    
}