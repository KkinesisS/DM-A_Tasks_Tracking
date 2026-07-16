$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"

$content = [System.IO.File]::ReadAllText($path)
$content = $content.Replace("`r`n", "`n")

# Replace 1: HTML container
$oldAvatar = '<div id="activeUserAvatar" title="Active User" style="min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background: #3b82f6; color: white; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; margin-left: 0.75rem; text-transform: uppercase; box-sizing: border-box; padding: 0; line-height: 1;">
                    ?
                </div>'
$newAvatar = '<div id="activeUsersContainer" style="display: flex; align-items: center; justify-content: flex-end; margin-left: 0.75rem; padding-left: 4px;"></div>'

if ($content.Contains($oldAvatar)) {
    $content = $content.Replace($oldAvatar, $newAvatar)
    Write-Host "Replaced Avatar HTML"
}

# Replace 2: updateUserAvatar
$oldUpdate = @"
function updateUserAvatar(username) {
    const avatarEl = document.getElementById('activeUserAvatar');
    if (avatarEl) {
        avatarEl.title = username || 'User';
        avatarEl.textContent = username ? username.charAt(0).toUpperCase() : '?';
        let hash = 0;
        for (let i = 0; i < (username || '').length; i++) {
            hash = username.charCodeAt(i) + ((hash << 5) - hash);
        }
        const colors = ['#ec4899', '#22c55e', '#8b5cf6', '#f59e0b', '#3b82f6', '#ef4444', '#14b8a6', '#f43f5e'];
        const bgColor = colors[Math.abs(hash) % colors.length];
        avatarEl.style.background = bgColor;
    }
}
"@
$newUpdate = @"
function renderActiveUsers(users) {
    const container = document.getElementById('activeUsersContainer');
    if (!container) return;
    container.innerHTML = '';
    
    // Remove duplicates
    const uniqueList = [...new Set(users)];
    
    uniqueList.slice(0, 5).forEach((u, index) => {
        const letter = u ? u.charAt(0).toUpperCase() : '?';
        let hash = 0;
        for (let i = 0; i < (u || '').length; i++) {
            hash = u.charCodeAt(i) + ((hash << 5) - hash);
        }
        const colors = ['#ec4899', '#22c55e', '#8b5cf6', '#f59e0b', '#3b82f6', '#ef4444', '#14b8a6', '#f43f5e'];
        const bgColor = colors[Math.abs(hash) % colors.length];
        
        const avatar = document.createElement('div');
        avatar.title = u;
        avatar.style.cssText = `min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background: ` + bgColor + `; color: white; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; text-transform: uppercase; box-sizing: border-box; padding: 0; line-height: 1; border: 2px solid var(--bg-card); margin-left: ` + (index > 0 ? '-12px' : '0') + `; z-index: ` + (10 - index) + `; box-shadow: 0 1px 3px rgba(0,0,0,0.1);`;
        avatar.textContent = letter;
        container.appendChild(avatar);
    });
    
    if (uniqueList.length > 5) {
        const more = document.createElement('div');
        more.title = `+` + (uniqueList.length - 5) + ` more users`;
        more.style.cssText = `min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background: var(--bg-card-hover); color: var(--text-secondary); display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; box-sizing: border-box; border: 2px solid var(--bg-card); margin-left: -12px; z-index: 1;`;
        more.textContent = `+` + (uniqueList.length - 5);
        container.appendChild(more);
    }
}

function updateUserAvatar(username) {
    window.localUsername = username;
    if (!window.currentOnlineUsers || window.currentOnlineUsers.length === 0) {
        renderActiveUsers([username]);
    }
}
"@

$oldUpdate = $oldUpdate.Replace("`r`n", "`n")
$newUpdate = $newUpdate.Replace("`r`n", "`n")
if ($content.Contains($oldUpdate)) {
    $content = $content.Replace($oldUpdate, $newUpdate)
    Write-Host "Replaced updateUserAvatar"
} else {
    Write-Host "Could not find updateUserAvatar block!"
}

# Replace 3: updateOnlineUserCountUI
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
            }
            
            const badgeEl = document.getElementById('onlineUsersBadge');
"@

$oldPresence = $oldPresence.Replace("`r`n", "`n")
$newPresence = $newPresence.Replace("`r`n", "`n")
if ($content.Contains($oldPresence)) {
    $content = $content.Replace($oldPresence, $newPresence)
    Write-Host "Replaced updateOnlineUserCountUI"
} else {
    Write-Host "Could not find updateOnlineUserCountUI block!"
}

[System.IO.File]::WriteAllText($path, $content)

# Do the same for index2.html
$path2 = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
if (Test-Path $path2) {
    $content2 = [System.IO.File]::ReadAllText($path2)
    $content2 = $content2.Replace("`r`n", "`n")
    if ($content2.Contains($oldAvatar)) {
        $content2 = $content2.Replace($oldAvatar, $newAvatar)
        [System.IO.File]::WriteAllText($path2, $content2)
        Write-Host "Replaced Avatar HTML in index2.html"
    }
}
