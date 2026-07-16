const fs = require('fs');

const goodAppJs = fs.readFileSync('app.js', 'utf8');

// We want to extract the content inside `const renderNotifications = () => { ... }` up to where `listEl.innerHTML = topActivities.map(act => { ... }).join('');` ends.
// Let's just find the `listEl.innerHTML = topActivities.map(act => {` block.

const startMarker = `listEl.innerHTML = topActivities.map(act => {`;
const endMarker = `    }).join('');`;

const startIdx = goodAppJs.indexOf(startMarker);
const endIdx = goodAppJs.indexOf(endMarker, startIdx) + endMarker.length;

const goodBlock = goodAppJs.substring(startIdx, endIdx);

const paths = [
    'index.html',
    'build/index.html',
    'build/app.html'
];

for (const p of paths) {
    if (!fs.existsSync(p)) continue;
    let content = fs.readFileSync(p, 'utf8');
    
    // In the HTML files, we need to find the same block, but it's corrupted.
    // The corrupted block starts with the same `listEl.innerHTML = topActivities.map(act => {`
    // And ends with `    }).join('');`
    
    const pStartIdx = content.indexOf(startMarker);
    const pEndIdx = content.indexOf(endMarker, pStartIdx) + endMarker.length;
    
    if (pStartIdx !== -1 && pEndIdx > pStartIdx) {
        content = content.substring(0, pStartIdx) + goodBlock + content.substring(pEndIdx);
        fs.writeFileSync(p, content, 'utf8');
        console.log(`Fixed ${p}`);
    } else {
        console.log(`Could not find block in ${p}`);
    }
}
