/* Service worker do Diário Mágico da Jade.
   Troque VERSION a cada publicação: o cache antigo é apagado e a casca é baixada de novo. */
const VERSION = "diario-2026-11-03g";
const SHELL = [
  "./", "./index.html", "./config.js", "./manifest.webmanifest", "./favicon.png",
  "./vendor/supabase.min.js", "./fonts/fonts.css",
  "./castle.jpg", "./crest.png", "./props.jpg", "./harry.jpg",
  "./sw.jpg", "./ppg.jpg", "./mario.jpg", "./gwen.jpg", "./samcat.jpg", "./bluey.jpg", "./final.jpg",
  "./icons/icon-192.png", "./icons/icon-512.png", "./icons/icon-512-maskable.png", "./icons/apple-touch-icon.png",
];

async function precache() {
  const c = await caches.open(VERSION);
  await c.addAll(SHELL);
  // As fontes ficam listadas dentro de fonts/fonts.css; lemos o arquivo para guardá-las também.
  try {
    const css = await (await fetch("./fonts/fonts.css")).text();
    const files = [...new Set([...css.matchAll(/url\(([^)]+)\)/g)].map(m => "./fonts/" + m[1].replace(/["']/g, "")))];
    await c.addAll(files);
  } catch (e) {}
}

self.addEventListener("install", e => { e.waitUntil(precache().then(() => self.skipWaiting())); });
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== VERSION && k.startsWith("diario-")).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});

function isShellPage(url) {
  return url.pathname.endsWith("/") || url.pathname.endsWith("index.html") || url.pathname.endsWith("config.js");
}

self.addEventListener("fetch", e => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  // Dados e login do Supabase: sempre pela rede, nunca pelo cache.
  if (url.hostname.endsWith("supabase.co") || url.hostname.endsWith("supabase.in")) return;
  // Qualquer outro domínio: pela rede, sem guardar.
  if (url.origin !== location.origin) return;

  if (isShellPage(url)) {
    // Página e configuração: rede primeiro (só guarda resposta boa); cache se estiver sem internet.
    e.respondWith(fetch(req).then(r => {
      if (r.ok) { const copy = r.clone(); caches.open(VERSION).then(c => c.put(req, copy)); }
      return r;
    }).catch(() => caches.match(req).then(r => r || caches.match("./index.html"))));
    return;
  }

  // Imagens, fontes e biblioteca: responde do cache e atualiza em segundo plano (stale-while-revalidate).
  e.respondWith(caches.match(req).then(hit => {
    const refresh = fetch(req).then(r => {
      if (r.ok) { const copy = r.clone(); caches.open(VERSION).then(c => c.put(req, copy)); }
      return r;
    }).catch(() => hit || Response.error());
    return hit || refresh;
  }));
});
