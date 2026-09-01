$html = Get-Content -Path "index.html.tmp" -Raw
$toastCss = @"
<style>
/* Toast Notification System */
.toast-container {
    position: fixed;
    bottom: 30px;
    right: 30px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    z-index: 999999;
    pointer-events: none;
}
.toast {
    min-width: 300px;
    max-width: 450px;
    background: rgba(27, 15, 30, 0.95);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    color: #fff;
    padding: 16px 20px;
    border-radius: 12px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
    font-family: var(--font-body, 'Inter', sans-serif);
    font-size: 0.9rem;
    line-height: 1.4;
    display: flex;
    align-items: center;
    gap: 12px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    transform: translateX(120%);
    opacity: 0;
    transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), opacity 0.4s ease;
}
.toast.show {
    transform: translateX(0);
    opacity: 1;
}
.toast-icon {
    flex-shrink: 0;
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
}
.toast-success .toast-icon {
    background: rgba(39, 174, 96, 0.2);
    color: #2ecc71;
}
.toast-error .toast-icon {
    background: rgba(231, 76, 60, 0.2);
    color: #e74c3c;
}
.toast-info .toast-icon {
    background: rgba(52, 152, 219, 0.2);
    color: #3498db;
}
.toast-message {
    flex-grow: 1;
}
.toast-close {
    cursor: pointer;
    background: none;
    border: none;
    color: rgba(255, 255, 255, 0.5);
    font-size: 1.2rem;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: color 0.2s;
    pointer-events: auto;
}
.toast-close:hover {
    color: #fff;
}
</style>
"@

$toastJsAndHtml = @"
<!-- Toast Notification Container -->
<div id="toast-container" class="toast-container"></div>
<script>
    function showToast(message, type = 'info') {
        const container = document.getElementById('toast-container');
        if (!container) return;
        
        const toast = document.createElement('div');
        toast.className = `"toast toast-`$type`";
        
        let iconSvg = '';
        if (type === 'success') {
            iconSvg = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>`;
        } else if (type === 'error') {
            iconSvg = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>`;
        } else {
            iconSvg = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>`;
        }
        
        toast.innerHTML = `<div class="toast-icon">`$iconSvg</div><div class="toast-message">`$message</div><button class="toast-close" onclick="this.parentElement.remove()">&times;</button>`;
        
        container.appendChild(toast);
        
        // Trigger reflow to apply animation
        toast.offsetHeight;
        toast.classList.add('show');
        
        // Auto-dismiss after 4 seconds
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 400);
        }, 4000);
    }
</script>
"@

$html = $html -replace "(?i)</head>", "`n$toastCss`n</head>"
$html = $html -replace "(?i)</body>", "`n$toastJsAndHtml`n</body>"

Set-Content -Path "index.html" -Value $html
Remove-Item "index.html.tmp"
