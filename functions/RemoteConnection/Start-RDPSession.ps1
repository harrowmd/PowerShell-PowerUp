﻿function Start-RDPSession{
    <#
	    .SYNOPSIS
		    Starts a remote desktop session

	    .DESCRIPTION
		    Starts a remote desktop session with the parameters from the Remote config file and a RDP file.

	    .PARAMETER  Names
		    Server names from the remote config file

	    .EXAMPLE
		    Start-RDPSession -Names sharepoint
            Start-RDPSession -Names sharepoint,dns

    #>

	#--------------------------------------------------#
	# Parameter
	#--------------------------------------------------#
	param (
        [parameter(Mandatory=$true)][string[]]
		$Names
	)

	$Metadata = @{
		Title = "Start a Remote Desktop Session"
		Filename = "Start-RDPSession.ps1"
		Description = ""
		Tags = "powershell, remote, session, rdp"
		Project = ""
		Author = "Janik von Rotz"
		AuthorContact = "www.janikvonrotz.ch"
		CreateDate = "2013-04-03"
		LastEditDate = "2013-04-08"
		Version = "1.0.0"
		License = @'
This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
    
    if ((Get-Command "cmdkey.exe") -and (Get-Command "mstsc.exe")) 
    { 

        #--------------------------------------------------#
        # Main
        #--------------------------------------------------#

        # Load Configurations
		$Config = Get-RemoteConfigurations -Names $Names

        foreach($Server in $Config){
		        
            $Servername = $Server.Server
            $Username = $Server.User

            # Delete existing user credentials
            $Null = Invoke-Expression "cmdkey /delete:'$Servername'"

            # Add user credentials
            $Null = Invoke-Expression "cmdkey /generic:'$Servername' /user:'$Username'"


            # Open remote session
            Invoke-Expression "mstsc.exe '$RDPDefaultFile' /v:$Servername"
	    }
    }
}