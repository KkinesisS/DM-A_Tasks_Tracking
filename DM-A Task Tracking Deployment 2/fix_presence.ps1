$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = [System.IO.File]::ReadAllText($path)
$content = $content.Replace("`r`n", "`n")

$oldPresence = @"
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
            const countEl = document.getElementById('onlineUsersCount');
            if (!badgeEl || !countEl) return;
            
            countEl.textContent = `${userCount} Active`;
            
            const usersList = [];
            Object.keys(presenceState).forEach(userKey => {
                const presences = presenceState[userKey];
                if (presences && presences.length > 0) {
                    const role = presences[0].role || 'User';
                    const countStr = presences.length > 1 ? ` (${presences.length} tabs)` : '';
                    usersList.push(`• ${userKey} (${role})${countStr}`);
                }
            });
            
            badgeEl.title = `Active sessions connected in real-time:\n${usersList.join('\n')}`;
        }
"@

$newPresence = @"
        function updateOnlineUserCountUI(userCount, totalConnections, presenceState) {
            const actualUsernames = [];
            const usersList = [];
            
            Object.keys(presenceState || {}).forEach(userKey => {
                const presences = presenceState[userKey];
                if (presences && presences.length > 0) {
                    const uname = presences[0].username || userKey;
                    actualUsernames.push(uname);
                    const role = presences[0].role || 'User';
                    const countStr = presences.length > 1 ? ` (` + presences.length + ` tabs)` : '';
                    usersList.push(`• ` + uname + ` (` + role + `)` + countStr);
                }
            });

            // Remove duplicates
            let uniqueUsers = [...new Set(actualUsernames)];
            
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
            const countEl = document.getElementById('onlineUsersCount');
            if (!badgeEl || !countEl) return;
            
            countEl.textContent = userCount + ` Active`;
            badgeEl.title = `Active sessions connected in real-time:\n` + usersList.join('\n');
        }
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
