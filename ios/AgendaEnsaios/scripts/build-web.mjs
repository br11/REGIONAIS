import { cp, mkdir, readFile, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';

const workspaceRoot = resolve(import.meta.dirname, '..');
const repositoryRoot = resolve(workspaceRoot, '../..');
const pwaRoot = resolve(repositoryRoot, 'pwa');
const webDir = resolve(workspaceRoot, 'www');

await mkdir(webDir, { recursive: true });

for (const file of ['index.html', 'style.css', 'manifest.json', 'sw.js']) {
  await cp(resolve(pwaRoot, file), resolve(webDir, file));
}

await cp(resolve(pwaRoot, 'icon'), resolve(webDir, 'icon'), { recursive: true });

const appScript = await readFile(resolve(pwaRoot, 'app.js'), 'utf8');
const serviceWorkerGuard = "if ('serviceWorker' in navigator) {";
const iosInstallGuard = 'if (isIosDevice && !isRunningStandalone) {';

if (appScript.split(serviceWorkerGuard).length !== 2 ||
    appScript.split(iosInstallGuard).length !== 2) {
  throw new Error('The PWA install or service worker code changed; update the iOS web build safely.');
}

const nativeAppScript = appScript
  .replace(
    serviceWorkerGuard,
    "const isNativeIosApp = window.webkit?.messageHandlers?.bridge !== undefined;\n\n" +
      "if (!isNativeIosApp && 'serviceWorker' in navigator) {"
  )
  .replace(
    iosInstallGuard,
    'if (isIosDevice && !isRunningStandalone && !isNativeIosApp) {'
  );

await writeFile(resolve(webDir, 'app.js'), nativeAppScript);

console.log(`iOS web assets copied from ${pwaRoot} to ${webDir}`);
