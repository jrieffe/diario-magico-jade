/* Service worker do Diário Mágico da Jade */
const VERSION = "diario-v1";
const SHELL = ["./", "./index.html", "./config.js", "./manifest.webmanifest", "./castle.jpg", "./crest.png", "./props.jpg", "./harry.jpg", "./favicon.png", "./icons/icon-192.png", "./icons/icon-512.png", "./icons/icon-512-maskable.png", "./icons/apple-touch-icon.png"];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(VERSION).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== VERSION).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  // Dados do Supabase: sempre pela rede.
  if (url.hostname.endsWith("supabase.co") || url.hostname.endsWith("supabase.in")) return;
  // Página e config: rede primeiro, cache como reserva.
  if (url.origin === location.origin && (url.pathname.endsWith("/") || url.pathname.endsWith("index.html") || url.pathname.endsWith("config.js"))) {
    e.respondWith(fetch(req).then(r => { const copy = r.clone(); caches.open(VERSION).then(c => c.put(req, copy)); return r; }).catch(() => caches.match(req).then(r => r || caches.match("./index.html"))));
    return;
  }
  // Demais arquivos (imagens, fontes, biblioteca): cache primeiro.
  e.respondWith(caches.match(req).then(hit => hit || fetch(req).then(r => { if (r.ok && (url.origin === location.origin || url.hostname.includes("fonts.g") || url.hostname.includes("jsdelivr"))) { const copy = r.clone(); caches.open(VERSION).then(c => c.put(req, copy)); } return r; })));
});
