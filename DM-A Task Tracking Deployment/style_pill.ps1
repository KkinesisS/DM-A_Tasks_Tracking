$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldCSS = @"
.col-count {
    background: rgba(0, 0, 0, 0.05);
    border-radius: 12px;
    padding: 2px 8px;
    font-size: 0.75rem;
    font-family: var(--font-heading);
    color: var(--text-secondary);
}

.kanban-col[data-status="Open"] .col-indicator { background: var(--status-open); }
"@
$oldCSS = $oldCSS.Replace("`r`n", "`n")

$newCSS = @"
.col-count {
    background: rgba(0, 0, 0, 0.05);
    border-radius: 9999px;
    padding: 2px 10px;
    font-size: 0.75rem;
    font-weight: 700;
    font-family: var(--font-heading);
    color: #ffffff;
    min-width: 24px;
    text-align: center;
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.kanban-col[data-status="Open"] .col-count { background: var(--status-open); }
.kanban-col[data-status="In Progress"] .col-count { background: var(--status-progress); }
.kanban-col[data-status="Pending Review"] .col-count { background: var(--status-review); }
.kanban-col[data-status="Completed"] .col-count { background: var(--status-completed); }

.kanban-col[data-status="Open"] .col-indicator { background: var(--status-open); }
"@
$newCSS = $newCSS.Replace("`r`n", "`n")

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        $content = $content.Replace("`r`n", "`n")
        
        if ($content.Contains($oldCSS)) {
            $content = $content.Replace($oldCSS, $newCSS)
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced col-count style in $($path)"
        } else {
            Write-Host "Could not find target CSS in $($path)"
        }
    }
}
