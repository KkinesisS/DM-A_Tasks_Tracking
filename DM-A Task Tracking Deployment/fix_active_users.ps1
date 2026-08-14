$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = [System.IO.File]::ReadAllText($path)
$content = $content.Replace("`r`n", "`n")

$oldPresence = @"
        function updateOnlineUserCountUI(userCount, totalConnections, presenceState) {
            const badgeEl = document.getElementById('onlineUsersBadge');
"@

$newPresence = @"
        function updateOnlineUserCountUI(userCount, totalConnections, presenceState) {
            const uniqueUsers = Object.keys(presenceState || {});
            
            // Add local user to the front
            let userListToRender = [...uniqueUsers];
            if (window.localUsername) {
                const localIdx = userListToRender.indexOf(window.localUsername);
                if (localIdx > -1) {
                    userListToRender.splice(localIdx, 1);
                }
                userListToRender.unshift(window.localUsername);
            }
            window.currentOnlineUsers = userListToRender;
            if (typeof renderActiveUsers === 'function') {
                renderActiveUsers(userListToRender);
            } else if (window.renderActiveUsers) {
                window.renderActiveUsers(userListToRender);
            }
            
            const badgeEl = document.getElementById('onlineUsersBadge');
"@

$oldPresence = $oldPresence.Replace("`r`n", "`n")
$newPresence = $newPresence.Replace("`r`n", "`n")

if ($content.Contains($oldPresence)) {
    $content = $content.Replace($oldPresence, $newPresence)
    [System.IO.File]::WriteAllText($path, $content)
    Write-Host "Replaced updateOnlineUserCountUI in index.html"
} else {
    Write-Host "Could not find updateOnlineUserCountUI block in index.html!"
}

# Do the same for index2.html
$path2 = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
if (Test-Path $path2) {
    $content2 = [System.IO.File]::ReadAllText($path2)
    $content2 = $content2.Replace("`r`n", "`n")
    if ($content2.Contains($oldPresence)) {
        $content2 = $content2.Replace($oldPresence, $newPresence)
        [System.IO.File]::WriteAllText($path2, $content2)
        Write-Host "Replaced updateOnlineUserCountUI in index2.html"
    } else {
        Write-Host "Could not find updateOnlineUserCountUI block in index2.html!"
    }
}
