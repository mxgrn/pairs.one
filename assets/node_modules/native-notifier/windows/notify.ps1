param($app, $icon, $title, $message)

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

$templateType = [Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText02
$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($templateType)

$template.SelectSingleNode("//image[@id=1]").SetAttribute("src", "file:\\\$icon")
$template.SelectSingleNode("//text[@id=1]").InnerText = $title
$template.SelectSingleNode("//text[@id=2]").InnerText = $message

$toast = [Windows.UI.Notifications.ToastNotification]::new($template)

$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app)
$notifier.Show($toast)
