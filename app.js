if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('./sw.js')
      .catch(error => console.error('Erro ao registrar o service worker:', error));
  });
}

let deferredInstallPrompt;

window.addEventListener('beforeinstallprompt', event => {
  event.preventDefault();
  deferredInstallPrompt = event;

  const installButton = document.createElement('button');
  installButton.id = 'install-btn';
  installButton.className = 'btn-reset pwa-install-button';
  installButton.type = 'button';
  installButton.innerHTML = '<i class="fa-solid fa-download" aria-hidden="true"></i> Instalar aplicativo';
  installButton.addEventListener('click', async () => {
    if (!deferredInstallPrompt) return;

    await deferredInstallPrompt.prompt();
    await deferredInstallPrompt.userChoice;
    deferredInstallPrompt = null;
    installButton.remove();
  });

  document.querySelector('.filter-card').append(installButton);
});

window.addEventListener('appinstalled', () => {
  deferredInstallPrompt = null;
  document.getElementById('install-btn')?.remove();
});
