param (
    [Parameter(Mandatory=$true)][string]$path
)

$content = Get-Content $path -Raw

$target1 = '<div style="padding: 1.5rem; text-align: center; color: var(--text-muted); font-size: 0.8rem; font-style: italic;">No recent activities</div>'
$replacement1 = '<div style="padding: 1.5rem; text-align: center; color: var(--text-muted); font-size: 0.8rem; font-style: italic;">No notifications</div>'
$content = $content.Replace($target1, $replacement1)

$target2 = @"
        const dateFormatted = new Date(act.timestamp).toLocaleDateString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false });

        return ``
            <div `${clickHandler} class="notification-item" style="display: flex; gap: 10px; padding: 0.75rem 1rem; border-bottom: 1px solid var(--border-color); cursor: pointer; transition: background 0.2s; align-items: flex-start; `${isUnread ? 'background: rgba(124, 58, 237, 0.03);' : ''}">
                <div style="width: 28px; height: 28px; border-radius: 50%; background: var(--bg-secondary); display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-top: 2px;">
                    `${iconHtml}
                </div>
                <div style="display: flex; flex-direction: column; flex-grow: 1; align-items: flex-start;">
                    <div style="display: flex; justify-content: space-between; width: 100%; align-items: center;">
                        <span style="font-size: 0.8rem; font-weight: 700; color: var(--text-primary); text-align: left;">`${act.title}</span>
                        `${isUnread ? '<span style="width: 6px; height: 6px; border-radius: 50%; background-color: var(--priority-aog);"></span>' : ''}
                    </div>
                    <span style="font-size: 0.75rem; color: var(--text-secondary); margin-top: 2px; text-align: left; line-height: 1.25;">`${act.description}</span>
                    <span style="font-size: 0.65rem; color: var(--text-muted); margin-top: 4px; font-weight: 500;">`${dateFormatted}</span>
                </div>
            </div>
        ``;
    }).join('');
"@

$replacement2 = @"
        // Format date like "Jul 23, 2021 at 09:15 AM"
        const d = new Date(act.timestamp);
        const dateStr = d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        const timeStr = d.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
        const dateFormatted = `${dateStr} at ${timeStr}`;

        let authorStr = '';
        let contentStr = act.description || '';
        if (contentStr.includes(': ')) {
            const split = contentStr.split(': ');
            authorStr = split[0];
            contentStr = split.slice(1).join(': ');
        }
        if (!authorStr && act.title) authorStr = act.title;
        const subtitle = authorStr ? `${authorStr} • ${dateFormatted}` : dateFormatted;

        const firstLetter = (authorStr || act.title || 'S').charAt(0).toUpperCase();
        let hash = 0;
        for (let i = 0; i < (authorStr || '').length; i++) {
            hash = authorStr.charCodeAt(i) + ((hash << 5) - hash);
        }
        const colors = ['#ec4899', '#22c55e', '#8b5cf6', '#f59e0b', '#3b82f6', '#ef4444', '#14b8a6', '#f43f5e'];
        const bgColor = colors[Math.abs(hash) % colors.length];

        const avatarHtml = ``
            <div style="width: 36px; height: 36px; border-radius: 50%; background-color: `${bgColor}; color: white; display: flex; align-items: center; justify-content: center; font-size: 1rem; font-weight: 600; flex-shrink: 0; font-family: var(--font-body);">
                `${firstLetter}
            </div>
        ``;

        return ``
            <div `${clickHandler} class="notification-item" style="display: flex; gap: 12px; padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-color); cursor: pointer; transition: background 0.2s; align-items: center;">
                <div style="width: 8px; height: 8px; border-radius: 50%; background-color: #3b82f6; opacity: `${isUnread ? '1' : '0'}; flex-shrink: 0;"></div>
                
                `${avatarHtml}
                
                <div style="display: flex; flex-direction: column; flex-grow: 1; align-items: flex-start;">
                    <span style="font-size: 0.9rem; font-weight: 500; color: var(--text-primary); text-align: left; line-height: 1.4; margin-bottom: 2px;">`${contentStr}</span>
                    <span style="font-size: 0.8rem; color: var(--text-muted);">`${subtitle}</span>
                </div>
            </div>
        ``;
    }).join('');
"@

$normalizedContent = $content -replace "`r`n", "`n"
$normalizedTarget2 = $target2 -replace "`r`n", "`n"
$normalizedReplacement2 = $replacement2 -replace "`r`n", "`n"

if ($normalizedContent.Contains($normalizedTarget2)) {
    $newContent = $normalizedContent.Replace($normalizedTarget2, $normalizedReplacement2)
    $newContent | Set-Content $path -NoNewline
    Write-Host "Replaced successfully $path!"
} else {
    Write-Host "Target2 not found in $path!"
}
