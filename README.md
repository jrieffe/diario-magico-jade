# O Diário Mágico da Jade — PWA

Calendário de comportamento instalável no celular e no iPad. O papai registra os 3 momentos do dia; a Jade acompanha a evolução e o percentual rumo ao iPhone 17.

## Como colocar para funcionar (uma vez só)

1. **Supabase** (banco de dados, gratuito)
   1. Crie uma conta em https://supabase.com e um projeto novo (região *South America (São Paulo)*).
   2. No menu **SQL Editor**, cole o conteúdo de `supabase.sql` e clique em **Run**.
   3. No menu **Authentication → Users → Add user → Create new user**, crie o usuário do papai (e-mail + senha). Marque *Auto confirm user*.
   4. Em **Project Settings → API**, copie a **Project URL** e a chave **anon public**.
2. **Chaves**: abra `config.js` e cole a URL e a chave anon.
3. **Publicação**: envie a pasta para o GitHub Pages (ou qualquer hospedagem estática). O endereço final fica no formato `https://SEU-USUARIO.github.io/diario-magico-jade/`.

## Instalar no iPad / iPhone

Abra o endereço no Safari → botão **Compartilhar** → **Adicionar à Tela de Início**. O app abre em tela cheia, com o brasão como ícone.

## Mensagem diária no iPad (app Atalhos)

Atalhos → **Automação** → **+** → **Hora do Dia** (ex.: 19h30, todos os dias) → **Executar imediatamente** → ação **Abrir App** → escolha *Diário Mágico* (ou **Abrir URL** com o endereço do app). Todo dia o diário abre sozinho mostrando a "Coruja do dia".

## Modo pai

Toque no cadeado no canto da capa, entre com o e-mail e a senha criados no Supabase. Sem login, a página é só leitura.
