import { chromium } from 'playwright';
import { mkdtempSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

// 32x32 PNG: magenta border on all four sides, green corner-to-corner
// diagonal. Real Beast art is this size, and the border is the tell — if the
// preview crops, an edge goes missing.
const TEST_PNG =
  'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAiklEQVR4nLXNSw6AIAyEYQ7B2vvfEk1sULFAHzOZf9FVv9JKoyar9WAk76+LZDwAyfgADGME4IYCYA0dABpTAGWsAIixAfLGHkgaJiBjWIGw4QBihg8IGG7Aa0QAlxEE7EYcMBopwGJkga0BANYGBlgYMGBmIAHVAAN/Aw8MBgV4GyygG0TgNmTUTqHjAu38soSbAAAAAElFTkSuQmCC';

const fixtureDir = mkdtempSync(join(tmpdir(), 'beasts-smoke-'));
const pngPath = join(fixtureDir, 'test.png');
writeFileSync(pngPath, Buffer.from(TEST_PNG, 'base64'));

const browser = await chromium.launch({
  executablePath:
    '/home/ubuntu/.cache/ms-playwright/chromium_headless_shell-1228/chrome-headless-shell-linux64/chrome-headless-shell',
});
const page = await browser.newPage({ viewport: { width: 1280, height: 1400 } });
const errors = [];
page.on('console', (m) => { if (m.type() === 'error') errors.push(m.text()); });
page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));

await page.goto('http://localhost:4173/', { waitUntil: 'domcontentloaded' });
await page.waitForTimeout(5000);

console.log('H1:', await page.textContent('h1'));
const body = await page.textContent('body');
const m = body.match(/(\d+) species in the bestiary so far/);
console.log('LIVE CHAIN READ:', m ? m[0] : 'FAILED — no species count rendered');
console.log('art slots:', await page.locator('.art-slot').count());
console.log('preview card:', await page.locator('.card').count());

// Client-side name validation, no wallet needed.
await page.fill('input[placeholder="Gloomfang"]', 'bad"name');
await page.waitForTimeout(200);
console.log('rejects injection name:', JSON.stringify(await page.locator('.field__error').first().textContent()));

await page.fill('input[placeholder="Gloomfang"]', 'Gloomfang');
await page.waitForTimeout(200);
console.log('accepts valid name — card title:', JSON.stringify(await page.textContent('.card__title')));

// Tier drives the power number on the preview card.
await page.selectOption('select >> nth=1', '1');
await page.waitForTimeout(200);
const power = await page.locator('.stat', { hasText: 'Power' }).textContent();
console.log('tier 1 power (level 10 x 5):', JSON.stringify(power));

// Preview sizing. A percentage height against an `aspect-ratio` parent
// resolves to `auto`, so a square Beast used to size itself from its own 1:1
// ratio, overflow the wider frame, and get cropped by `overflow: hidden`.
await page.locator('.art-slot__drop input[type=file]').first().setInputFiles(pngPath);
await page.waitForTimeout(1200);
const artBox = await page.locator('.card__art').boundingBox();
const imgBox = await page.locator('.card__art img').boundingBox();
console.log('preview art fits its frame:',
  imgBox.height <= artBox.height + 1 && imgBox.width <= artBox.width + 1,
  `(img ${Math.round(imgBox.width)}x${Math.round(imgBox.height)} in frame ${Math.round(artBox.width)}x${Math.round(artBox.height)})`);

await page.screenshot({ path: 'smoke-register.png', fullPage: true });

// Dashboard for the live species 76.
await page.fill('input[placeholder="Species #"]', '76');
await page.click('.lookup button');
await page.waitForTimeout(5000);
console.log('dashboard heading:', JSON.stringify(await page.textContent('.dashboard__header h2').catch(() => null)));
console.log('dashboard meta:', JSON.stringify(await page.textContent('.dashboard__header p').catch(() => null)));
console.log('badges:', await page.locator('.badge').allTextContents());
console.log('read-only notice:', JSON.stringify(await page.textContent('.notice').catch(() => null)));
await page.screenshot({ path: 'smoke-dashboard.png', fullPage: true });

// Wallet picker: both wallet families must be offered, and a wallet whose
// extension is absent must say so rather than fail silently.
await page.click('.brand');
await page.waitForTimeout(500);
await page.click('button.primary:has-text("Connect")');
await page.waitForSelector('.modal', { state: 'visible', timeout: 5000 });
const wallets = await page.locator('.wallet__name').allTextContents();
const states = await page.locator('.wallet__state').allTextContents();
console.log('wallets offered:', wallets.map((w, i) => `${w}${states[i] ? ` (${states[i]})` : ''}`));
// A centred fixed overlay: narrow, and vertically centred in the viewport
// whatever the page scroll position.
const box = await page.locator('.modal').boundingBox();
const vh = page.viewportSize().height;
const centred = Math.abs(box.y + box.height / 2 - vh / 2) < 40;
console.log('modal is a centred overlay:', box.width <= 400 && centred);

console.log('CONSOLE ERRORS:', errors.length ? errors.slice(0, 4) : 'none');
await browser.close();
