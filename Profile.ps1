if ( -not ( Get-Module posh-git -ListAvailable ) ) {
	PowerShellGet\Install-Module -Module posh-git -Scope CurrentUser
}

$git = Get-Command git -ErrorAction SilentlyContinue

if ($git)
{
	$usrBin = Resolve-Path -Path ( Join-Path -Path $git.Source "..\..\usr\bin" )
	$sshAddPath = Join-Path -Path $usrBin -ChildPath "ssh-add.exe"
	$sshAgentPath = Join-Path -Path $usrBin -ChildPath "ssh-agent.exe"

	Set-Alias ssh-add $sshAddPath
	Set-Alias ssh-agent $sshAgentPath
}

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
	PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser
}

Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-Location C:\_cp