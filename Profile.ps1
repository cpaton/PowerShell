if ( -not ( Get-Module PsGet -ListAvailable ) ) {
	(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
}
Import-Module PsGet

if ( -not ( Get-Module posh-git -ListAvailable ) ) {
	PsGet\Install-Module -Module posh-git -DoNotPostInstall
}
Set-Alias ssh-add "C:\Program Files\Git\usr\bin\ssh-add.exe"
Set-Alias ssh-agent "C:\Program Files\Git\usr\bin\ssh-agent.exe"

Import-Module posh-git
$GitPromptSettings.EnableWindowTitle = $false
Start-SshAgent -Quiet

function global:prompt() {
	$realLASTEXITCODE = $LASTEXITCODE

	Write-Host "PS $($executionContext.SessionState.Path.CurrentLocation)" -NoNewLine
	Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE

	"$('>' * ($nestedPromptLevel + 1)) "
}

if ( -not ( Get-Module PSReadLine -ListAvailable ) ) {
	PowerShellGet\Install-Module -Name PSReadLine
}

Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-Location C:\_cp

function Initialize-Docker() {
	[CmdletBinding()]
	param()

	# Make sure docker host is running
	if ( ( docker-machine status default ) -ne "Running" ) {
	    docker-machine start default
	    "yes" | docker-machine regenerate-certs default
	}

	# Get machine information and setup the environment so that we can use the docker tool
	docker-machine env default --shell powershell | Invoke-Expression
	Write-Host ( "Docker machine IP address is {0}" -f ( docker-machine ip default ) )
}
Set-Alias dockerinit Initialize-Docker