if ( -not ( Get-Module posh-git -ListAvailable ) ) {
	Install-Module -Name posh-git
}
Set-Alias ssh-add "C:\Program Files\Git\usr\bin\ssh-add.exe"
Set-Alias ssh-agent "C:\Program Files\Git\usr\bin\ssh-agent.exe"

Import-Module posh-git
$GitPromptSettings.EnableWindowTitle = $false

function global:prompt() {
	Write-Host "PS $($executionContext.SessionState.Path.CurrentLocation)" -NoNewLine
	Write-VcsStatus
	"$('>' * ($nestedPromptLevel + 1)) "
}

if ( -not ( Get-Module PSReadLine -ListAvailable ) ) {
	Install-Module -Name PSReadLine
}

Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-Location C:\_cp