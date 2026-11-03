-- Diário Mágico da Jade — estrutura do banco (Supabase → SQL Editor → New query → colar → Run)

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

alter table public.config enable row level security;
alter table public.days enable row level security;

-- Qualquer pessoa (a Jade, sem login) pode ler.
drop policy if exists "leitura publica config" on public.config;
create policy "leitura publica config" on public.config for select using (true);
drop policy if exists "leitura publica days" on public.days;
create policy "leitura publica days" on public.days for select using (true);

-- Só quem fez login (o papai) pode gravar.
drop policy if exists "escrita autenticada config" on public.config;
create policy "escrita autenticada config" on public.config for all to authenticated using (true) with check (true);
drop policy if exists "escrita autenticada days" on public.days;
create policy "escrita autenticada days" on public.days for all to authenticated using (true) with check (true);

-- Dados iniciais da missão.
insert into public.config (id, start_date, end_date, target, prize)
values ('main', '2026-11-02', '2026-12-24', 80, 'iPhone 17')
on conflict (id) do nothing;

-- Atualização em tempo real no iPad da Jade.
alter publication supabase_realtime add table public.days;
alter publication supabase_realtime add table public.config;
