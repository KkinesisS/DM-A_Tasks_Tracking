$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldHtml = @"
                    </div>
                </div>
            </div>
        </header>
"@

$newHtml = @"
                    </div>
                </div>

                <!-- Active User Avatar -->
                <div id="activeUserAvatar" title="Active User" style="width: 36px; height: 36px; border-radius: 50%; background: #3b82f6; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: 600; font-family: var(--font-body); cursor: default; flex-shrink: 0; margin-left: 0.75rem; text-transform: uppercase;">
                    ?
                </div>

            </div>
        </header>
"@

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        $content = $content.Replace("`r`n", "`n")
        $oldStr = $oldHtml.Replace("`r`n", "`n")
        $newStr = $newHtml.Replace("`r`n", "`n")
        if ($content.Contains($oldStr)) {
            $content = $content.Replace($oldStr, $newStr)
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced successfully in $($path)"
        } else {
            Write-Host "Not found in $($path)"
        }
    }
}
