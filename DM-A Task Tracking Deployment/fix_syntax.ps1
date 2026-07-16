$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = [System.IO.File]::ReadAllText($path)

# Extract the bad block roughly between function renderActiveUsers(users) { and function updateUserAvatar(username) {
$pattern = '(?s)function renderActiveUsers\(users\) \{.*?function updateUserAvatar\(username\)'

# I will just replace the exact broken strings
$badString1 = 'avatar.style.cssText = min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background:  + bgColor + ; color: white; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; text-transform: uppercase; box-sizing: border-box; padding: 0; line-height: 1; border: 2px solid var(--bg-card); margin-left:  + (index > 0 ? ''-12px'' : ''0'') + ; z-index:  + (10 - index) + ; box-shadow: 0 1px 3px rgba(0,0,0,0.1);;'
$goodString1 = 'avatar.style.cssText = "min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background: " + bgColor + "; color: white; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; text-transform: uppercase; box-sizing: border-box; padding: 0; line-height: 1; border: 2px solid var(--bg-card); margin-left: " + (index > 0 ? "-12px" : "0") + "; z-index: " + (10 - index) + "; box-shadow: 0 1px 3px rgba(0,0,0,0.1);";'

$badString2 = 'more.title = + + (uniqueList.length - 5) +  more users;'
$goodString2 = 'more.title = "+" + (uniqueList.length - 5) + " more users";'

$badString3 = 'more.style.cssText = min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background: var(--bg-card-hover); color: var(--text-secondary); display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; box-sizing: border-box; border: 2px solid var(--bg-card); margin-left: -12px; z-index: 1;;'
$goodString3 = 'more.style.cssText = "min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background: var(--bg-card-hover); color: var(--text-secondary); display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; box-sizing: border-box; border: 2px solid var(--bg-card); margin-left: -12px; z-index: 1;";'

$badString4 = 'more.textContent = + + (uniqueList.length - 5);'
$goodString4 = 'more.textContent = "+" + (uniqueList.length - 5);'

if ($content.Contains($badString1)) {
    $content = $content.Replace($badString1, $goodString1)
    Write-Host "Fixed string 1"
} else { Write-Host "Failed to find string 1" }

if ($content.Contains($badString2)) {
    $content = $content.Replace($badString2, $goodString2)
    Write-Host "Fixed string 2"
} else { Write-Host "Failed to find string 2" }

if ($content.Contains($badString3)) {
    $content = $content.Replace($badString3, $goodString3)
    Write-Host "Fixed string 3"
} else { Write-Host "Failed to find string 3" }

if ($content.Contains($badString4)) {
    $content = $content.Replace($badString4, $goodString4)
    Write-Host "Fixed string 4"
} else { Write-Host "Failed to find string 4" }

[System.IO.File]::WriteAllText($path, $content)
