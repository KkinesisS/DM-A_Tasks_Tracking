$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = [System.IO.File]::ReadAllText($path)

$oldPattern = '(?s)function updateOnlineUserCountUI\(userCount, totalConnections, presenceState\) \{.*?const badgeEl = document\.getElementById\(''onlineUsersBadge''\);'

$newReplacement = @"
        function updateOnlineUserCountUI(userCount, totalConnections, presenceState) {
            const presenceUsernames = [];
            Object.keys(presenceState || {}).forEach(key => {
                const presences = presenceState[key];
                if (presences && presences.length > 0 && presences[0].username) {
                    presenceUsernames.push(presences[0].username);
                }
            });
            const uniqueUsers = [...new Set(presenceUsernames)];
            
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
            }
            
            const badgeEl = document.getElementById('onlineUsersBadge');
"@

$content = $content -replace $oldPattern, $newReplacement

# Also fix the tooltip part of updateOnlineUserCountUI
$oldTooltip = @"
            const usersList = [];
            Object.keys(presenceState).forEach(userKey => {
                const presences = presenceState[userKey];
                if (presences && presences.length > 0) {
                    const role = presences[0].role || 'User';
                    const countStr = presences.length > 1 ? ` (${presences.length} tabs)` : '';
                    usersList.push(`• ${userKey} (${role})${countStr}`);
                }
            });
"@
$oldTooltip = $oldTooltip.Replace("`r`n", "`n")

$newTooltip = @"
            const usersList = [];
            Object.keys(presenceState).forEach(userKey => {
                const presences = presenceState[userKey];
                if (presences && presences.length > 0) {
                    const uname = presences[0].username || userKey;
                    const role = presences[0].role || 'User';
                    const countStr = presences.length > 1 ? ` (` + presences.length + ` tabs)` : '';
                    usersList.push(`• ` + uname + ` (` + role + `)` + countStr);
                }
            });
"@
$newTooltip = $newTooltip.Replace("`r`n", "`n")

$content = $content.Replace("`r`n", "`n")
if ($content.Contains($oldTooltip)) {
    $content = $content.Replace($oldTooltip, $newTooltip)
    Write-Host "Fixed Tooltip"
} else {
    Write-Host "Could not find tooltip block"
}

[System.IO.File]::WriteAllText($path, $content)
Write-Host "Fixed Usernames"
