# O Diário Mágico da Jade — PWA

Calendário de comportamento instalável no celular e no iPad. O papai registra os 3 momentos do dia; a Jade acompanha a evolução e o percentual rumo ao iPhone 17.

Endereço publicado: https://jrieffe.github.io/diario-magico-jade/

## 1. Banco de dados (Supabase, gratuito) — uma vez só

1. Crie uma conta em https://supabase.com e um projeto novo (região *South America (São Paulo)*).
2. **Authentication → Users → Add user → Create new user**: crie o usuário do papai (e-mail + senha) e marque *Auto confirm user*. Use o mesmo e-mail que está no início de `supabase.sql` (`jrieffe@gmail.com`); se quiser outro, troque lá antes do passo 3.
3. **SQL Editor → New query**: cole todo o conteúdo de `supabase.sql` e clique em **Run**. Pode rodar de novo sempre que o arquivo for atualizado.
4. **Authentication → Sign In / Providers → Email**: desligue **Allow new users to sign up**. Sem isso, qualquer pessoa poderia criar conta no projeto.
5. **Project Settings → API Keys**: copie a **Project URL** e a chave **Publishable** (começa com `sb_publishable_`). Cole as duas em `config.js`. Essa chave pode ficar pública: ela só permite o que as políticas do banco liberam (leitura para todos, escrita só para o e-mail do papai).

## 2. Publicar no GitHub Pages (gratuito)

1. Crie um repositório **público** no GitHub (ex.: `diario-magico-jade`) e envie esta pasta inteira para a branch `main`.
2. No repositório: **Settings → Pages → Build and deployment → Source: Deploy from a branch → Branch: main / (root) → Save**.
3. Em cerca de um minuto o site aparece em `https://SEU-USUARIO.github.io/diario-magico-jade/`.
4. A cada mudança nos arquivos, troque o texto de `VERSION` no início de `sw.js` (ex.: a data do dia) antes de enviar: é isso que faz os aparelhos já instalados baixarem a versão nova.

## 3. Instalar no iPad / iPhone

Abra o endereço no Safari → botão **Compartilhar** → **Adicionar à Tela de Início**. O app abre em tela cheia, com o brasão como ícone. Sem internet ele mostra o último diário salvo.

## 4. Mensagem diária no iPad (app Atalhos)

Atalhos → **Automação** → **+** → **Hora do Dia** (ex.: 19h30, todos os dias) → **Executar imediatamente** → ação **Abrir URL** com o endereço do app. Todo dia o diário abre sozinho mostrando a "Coruja do dia". (Apps adicionados pelo Safari não aparecem na ação "Abrir App"; por isso use "Abrir URL".)

## 5. Modo pai

Toque no cadeado no canto da capa, entre com o e-mail e a senha criados no passo 1. Sem login, a página é só leitura. Para sair, toque no cadeado de novo ou em "Encerrar modo pai" nos ajustes.
