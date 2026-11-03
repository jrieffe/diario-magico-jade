-- Diário Mágico da Jade — estrutura e segurança do banco.
-- Supabase → SQL Editor → New query → colar tudo → Run.
-- Pode ser executado quantas vezes quiser: nada é duplicado nem apagado.

-- 1) Quem pode escrever: SÓ o usuário com este e-mail (o papai).
--    Troque o e-mail abaixo se o seu usuário no Supabase usar outro.
create or replace function public.is_papai() returns boolean
language sql stable
set search_path = ''
as $$
  select lower(coalesce(auth.jwt() ->> 'email', '')) = lower('jrieffe@gmail.com');
$$;

-- 2) Tabelas
create table if not exists public.config (
  id text primary key,
  start_date date not null,
  end_date date not null,
  target integer not null default 80 check (target between 50 and 100),
  prize text not null default 'iPhone 17'
);

create table if not exists public.days (
  date date primary key,
  m smallint check (m between -2 and 2),
  t smallint check (t between -2 and 2),
  n smallint check (n between -2 and 2),
  note text not null default '',
  updated_at timestamptz not null default now()
);

alter table public.days drop constraint if exists days_note_len;
alter table public.days add constraint days_note_len check (char_length(note) <= 500);
alter table public.config drop constraint if exists config_dates;
alter table public.config add constraint config_dates check (end_date >= start_date);

-- 3) Segurança por linha
alter table public.config enable row level security;
alter table public.days enable row level security;

-- Qualquer pessoa (a Jade, sem login) pode ler.
drop policy if exists "leitura publica config" on public.config;
create policy "leitura publica config" on public.config for select using (true);
drop policy if exists "leitura publica days" on public.days;
create policy "leitura publica days" on public.days for select using (true);

-- Só o papai (e-mail acima) pode gravar. Outras contas, mesmo logadas, não conseguem.
drop policy if exists "escrita autenticada config" on public.config;
drop policy if exists "escrita papai config" on public.config;
create policy "escrita papai config" on public.config for all to authenticated
  using (public.is_papai()) with check (public.is_papai());
drop policy if exists "escrita autenticada days" on public.days;
drop policy if exists "escrita papai days" on public.days;
create policy "escrita papai days" on public.days for all to authenticated
  using (public.is_papai()) with check (public.is_papai());

-- 4) Dados iniciais da missão
insert into public.config (id, start_date, end_date, target, prize)
values ('main', '2026-11-02', '2026-12-24', 80, 'iPhone 17')
on conflict (id) do nothing;

-- 5) Atualização em tempo real no iPad da Jade (não duplica se já estiver ligada)
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'days') then
    alter publication supabase_realtime add table public.days;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'config') then
    alter publication supabase_realtime add table public.config;
  end if;
end $$;

-- 6) OBRIGATÓRIO (fora do SQL): em Authentication → Sign In / Providers → Email,
--    DESLIGUE "Allow new users to sign up" e mantenha "Secure email change" LIGADO.
--    Sem isso, qualquer pessoa com a chave pública poderia criar uma conta no projeto.
--    Observação: um PATCH anônimo responde 204 sem gravar nada (comportamento do PostgREST
--    com RLS); a escrita real é recusada, como mostram os POSTs com erro 401.
