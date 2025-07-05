$UWPAppstoRemove = @(
	"Microsoft.BingNews",
	"Microsoft.GamingApp",
	"Microsoft.MicrosoftSolitaireCollection",
	"Microsoft.WindowsCommunicationsApps",
	"Microsoft.WindowsFeedbackHub",
	"Microsoft.XboxGameOverlay",
	"Microsoft.XboxGamingOverlay",
	"Microsoft.XboxIdentityProvider",
	"Microsoft.XboxSpeechToTextOverlay",
	"Microsoft.YourPhone",
	"Microsoft.ZuneMusic",
	"Microsoft.ZuneVideo",
	"MicrosoftTeams",
	"Microsoft.OutlookForWindows",
	"Microsoft.Windows.DevHome",
	"Microsoft.MicrosoftOfficeHub",
	"Microsoft.MicrosoftStickyNotes",
	"Microsoft.People",
	"Microsoft.ScreenSketch",
	"microsoft.windowscommunicationsapps",
	"Microsoft.WindowsFeedbackHub",
	"Microsoft.WindowsMaps",
	"Microsoft.Todos",
	"Clipchamp.Clipchamp",
	"Microsoft.GetHelp",
	"Microsoft.Xbox.TCUI",
	"A025C540.Yandex.Music"
)
# Удаление установленные приложений у всех пользователей и из образа Windows
foreach ($UWPApp in $UWPAppstoRemove) {
	Get-AppxPackage -Name $UWPApp -AllUsers | Remove-AppxPackage -AllUsers -verbose
	Get-AppXProvisionedPackage -Online | Where-Object DisplayName -eq $UWPApp | Remove-AppxProvisionedPackage -Online -verbose
}