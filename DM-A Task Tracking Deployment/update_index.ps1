$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = [System.IO.File]::ReadAllText($path)

$old1 = @"
                        <!-- Notification Badge -->
                        <span id="notificationBadge" class="hidden" style="position: absolute; top: 0; right: 0; width: 8px; height: 8px; background-color: var(--priority-aog); border-radius: 50%; border: 1.5px solid var(--bg-card);"></span>
"@

$new1 = @"
                        <!-- Notification Badge -->
                        <span id="notificationBadge" class="hidden" style="position: absolute; top: -5px; right: -5px; min-width: 16px; height: 16px; display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: bold; color: white; background-color: var(--priority-aog); border-radius: 8px; padding: 0 4px; box-sizing: border-box; border: 1.5px solid var(--bg-card);"></span>
"@

$old2 = @"
    let hasUnread = false;

    if (topActivities.length === 0) {
        listEl.innerHTML = `<div style="padding: 1.5rem; text-align: center; color: var(--text-muted); font-size: 0.8rem; font-style: italic;">No notifications</div>`;
        if (badgeEl) badgeEl.classList.add('hidden');
        return;
    }

    listEl.innerHTML = topActivities.map(act => {
        const actTime = new Date(act.timestamp).getTime() || 0;
        const isUnread = actTime > lastReadTime;
        if (isUnread) hasUnread = true;
"@

$new2 = @"
    let hasUnread = false;
    let unreadCount = 0;

    if (topActivities.length === 0) {
        listEl.innerHTML = `<div style="padding: 1.5rem; text-align: center; color: var(--text-muted); font-size: 0.8rem; font-style: italic;">No notifications</div>`;
        if (badgeEl) badgeEl.classList.add('hidden');
        return;
    }

    listEl.innerHTML = topActivities.map(act => {
        const actTime = new Date(act.timestamp).getTime() || 0;
        const isUnread = actTime > lastReadTime;
        if (isUnread) {
            hasUnread = true;
            unreadCount++;
        }
"@

$old3 = @"
    if (badgeEl) {
        if (hasUnread) {
            badgeEl.classList.remove('hidden');
        } else {
            badgeEl.classList.add('hidden');
        }
    }
}
"@

$new3 = @"
    if (badgeEl) {
        if (hasUnread) {
            badgeEl.textContent = unreadCount > 9 ? '9+' : unreadCount;
            badgeEl.classList.remove('hidden');
        } else {
            badgeEl.textContent = '';
            badgeEl.classList.add('hidden');
        }
    }
}
"@

# Since git config usually replaces \r\n with \n, let's normalize both the file content and strings to \n for replacement
$content = $content.Replace("`r`n", "`n")
$old1 = $old1.Replace("`r`n", "`n")
$new1 = $new1.Replace("`r`n", "`n")
$old2 = $old2.Replace("`r`n", "`n")
$new2 = $new2.Replace("`r`n", "`n")
$old3 = $old3.Replace("`r`n", "`n")
$new3 = $new3.Replace("`r`n", "`n")

$content = $content.Replace($old1, $new1)
$content = $content.Replace($old2, $new2)
$content = $content.Replace($old3, $new3)

[System.IO.File]::WriteAllText($path, $content)
Write-Host "Replaced successfully"
