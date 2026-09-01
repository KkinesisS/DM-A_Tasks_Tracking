$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"

$content = [System.IO.File]::ReadAllText($path)
$content = $content.Replace("`r`n", "`n")

# Replace 1: checkAuthentication
$old1 = @"
        if (typeof window.trackPresence === 'function') {
            window.trackPresence(username, role);
        }
        
        initApp();
"@
$new1 = @"
        if (typeof window.trackPresence === 'function') {
            window.trackPresence(username, role);
        }
        updateUserAvatar(username);
        
        initApp();
"@

# Replace 2: Add updateUserAvatar before handleLogin
$old2 = @"
    }
}

// Handle login submission
"@
$new2 = @"
    }
}

// Update Active User Avatar UI
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

// Handle login submission
"@

# Replace 3: handleLogin GAS
$old3 = @"
                    // Track online presence
                    if (typeof window.trackPresence === 'function') {
                        window.trackPresence(usernameInput, authResult.user.role);
                    }
                    
                    document.getElementById('loginOverlay').style.display = 'none';
"@
$new3 = @"
                    // Track online presence
                    if (typeof window.trackPresence === 'function') {
                        window.trackPresence(usernameInput, authResult.user.role);
                    }
                    updateUserAvatar(usernameInput);
                    
                    document.getElementById('loginOverlay').style.display = 'none';
"@

# Replace 4: handleLogin Local
$old4 = @"
                // Track online presence
                if (typeof window.trackPresence === 'function') {
                    window.trackPresence(usernameInput, 'Administrator');
                }
                
                document.getElementById('loginOverlay').style.display = 'none';
"@
$new4 = @"
                // Track online presence
                if (typeof window.trackPresence === 'function') {
                    window.trackPresence(usernameInput, 'Administrator');
                }
                updateUserAvatar(usernameInput);
                
                document.getElementById('loginOverlay').style.display = 'none';
"@

$old1 = $old1.Replace("`r`n", "`n")
$new1 = $new1.Replace("`r`n", "`n")
$old2 = $old2.Replace("`r`n", "`n")
$new2 = $new2.Replace("`r`n", "`n")
$old3 = $old3.Replace("`r`n", "`n")
$new3 = $new3.Replace("`r`n", "`n")
$old4 = $old4.Replace("`r`n", "`n")
$new4 = $new4.Replace("`r`n", "`n")

$count1 = 0
if ($content.Contains($old1)) {
    $content = $content.Replace($old1, $new1)
    $count1++
}

$count2 = 0
if ($content.Contains($old2)) {
    $content = $content.Replace($old2, $new2)
    $count2++
}

$count3 = 0
if ($content.Contains($old3)) {
    $content = $content.Replace($old3, $new3)
    $count3++
}

$count4 = 0
if ($content.Contains($old4)) {
    $content = $content.Replace($old4, $new4)
    $count4++
}

[System.IO.File]::WriteAllText($path, $content)
Write-Host "Replaced 1: $count1"
Write-Host "Replaced 2: $count2"
Write-Host "Replaced 3: $count3"
Write-Host "Replaced 4: $count4"
