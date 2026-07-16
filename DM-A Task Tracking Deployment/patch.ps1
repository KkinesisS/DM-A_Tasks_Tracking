$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = Get-Content $path -Raw
$target = @"
                    <!-- Notification Panel -->
                    <div id="notificationPanel" class="dropdown-content hidden" style="position: absolute; right: 0; top: 100%; margin-top: 0.5rem; background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); z-index: 1000; width: 320px; max-height: 400px; display: flex; flex-direction: column; overflow: hidden;">
                        <div class="notification-header" style="display: flex; justify-content: space-between; align-items: center; padding: 0.75rem 1rem; border-bottom: 1px solid var(--border-color); background: var(--bg-secondary);">
                            <span style="font-size: 0.85rem; font-weight: 700; color: var(--text-primary);">Recent Activities</span>
                            <button id="markAllReadBtn" style="background: none; border: none; font-size: 0.75rem; color: var(--status-progress); font-weight: 600; cursor: pointer; padding: 0; font-family: var(--font-body);">Mark read</button>
                        </div>
                        <div id="notificationList" style="display: flex; flex-direction: column; overflow-y: auto; max-height: 340px;">
                            <!-- Dynamically populated updates will go here -->
                        </div>
                    </div>
"@
$replacement = @"
                    <!-- Notification Panel -->
                    <div id="notificationPanel" class="dropdown-content hidden" style="position: absolute; right: 0; top: 100%; margin-top: 0.5rem; background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 8px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); z-index: 1000; width: 340px; display: flex; flex-direction: column; overflow: hidden; padding-bottom: 0;">
                        <div class="notification-header" style="display: flex; justify-content: space-between; align-items: center; padding: 1.25rem 1.25rem 1rem 1.25rem;">
                            <span style="font-size: 1.05rem; font-weight: 600; color: var(--text-primary);">Notifications</span>
                            <button id="markAllReadBtn" style="background: none; border: none; font-size: 0.85rem; color: #3b82f6; font-weight: 500; cursor: pointer; padding: 0; font-family: var(--font-body); display: flex; align-items: center; gap: 4px;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 16px; height: 16px;">
                                    <path d="M18 6L7 17l-5-5"></path>
                                    <path d="M22 10l-5.5 5.5"></path>
                                </svg>
                                Mark as read
                            </button>
                        </div>
                        <div id="notificationList" style="display: flex; flex-direction: column; overflow-y: auto; max-height: 400px;">
                            <!-- Dynamically populated updates will go here -->
                        </div>
                        <div class="notification-footer" style="padding: 1rem 1.25rem; text-align: left; border-top: 1px solid var(--border-color);">
                            <a href="#" style="color: #3b82f6; font-size: 0.9rem; text-decoration: none; font-weight: 500;">View all notifications</a>
                        </div>
                    </div>
"@

$normalizedContent = $content -replace "`r`n", "`n"
$normalizedTarget = $target -replace "`r`n", "`n"
$normalizedReplacement = $replacement -replace "`r`n", "`n"

if ($normalizedContent.Contains($normalizedTarget)) {
    $newContent = $normalizedContent.Replace($normalizedTarget, $normalizedReplacement)
    $newContent | Set-Content $path -NoNewline
    Write-Host "Replaced successfully!"
} else {
    Write-Host "Target not found!"
}
