# InteraEdu

> Rede social acadêmica exclusiva para universitários, com identidade verificada por e-mail institucional.

---

## 📌 Visão Geral do Projeto

O **InteraEdu** é uma rede social acadêmica restrita a estudantes e pesquisadores verificados por e-mail institucional (domínio da universidade). O problema que o sistema resolve é o **isolamento entre comunidades acadêmicas**: hoje, redes sociais genéricas não separam nem conectam estudantes por instituição de ensino, e não existe um espaço confiável, verificado e livre de ranking competitivo para troca acadêmica entre universidades.

A tese central do produto, "quebrar silos entre universidades", é sustentada pela regra de **Exploração Forçada** (RN-03): o feed global sempre injeta pelo menos 20% de conteúdo de outras instituições, misturado ao conteúdo local, para incentivar a troca entre IES em vez de bolhas isoladas por faculdade.

O sistema é multi-tenant (uma instituição de ensino = um tenant) e foi desenhado com privacidade e LGPD desde a fundação: consentimento versionado, exportação de dados em até 48h, exclusão de conta com anonimização em 30 dias e trilha de auditoria de 5 anos.

**Principais funcionalidades do MVP:**
- Cadastro e login com verificação por e-mail institucional (OTP) e login Google
- Perfil acadêmico (curso, período, habilidades, links) com 3 níveis de privacidade
- Conexões entre usuários (solicitar/aceitar/rejeitar)
- Feed de publicações (local e global) com reações e comentários
- Mensagens em tempo real (chat 1:1 e grupos de estudo) via WebSocket
- Painel de administração e moderação de denúncias

---

## ⚙️ Guia de Instalação/Execução

### Pré-requisitos
- Docker Desktop (>= 24.x) com Docker Compose v2
- Node.js 20+ (apenas se for rodar algum serviço fora do Docker)
- Flutter 3.11+ (Dart) para o app mobile

### 1. Backend (microsserviços via Docker)

```bash
cd backend
cp .env.example .env      # preencha as variáveis de ambiente necessárias
docker-compose up --build
```

Isso sobe 7 containers: `postgres`, `redis`, `minio`, e os 5 serviços de aplicação (`gateway`, `auth-service`, `profile-service`, `feed-service`, `messaging-service`), além de `prometheus` e `grafana` para observabilidade.

O API Gateway fica disponível em `http://localhost:3000/api/v1`.

| Serviço | URL |
|---|---|
| API Gateway | http://localhost:3000/api/v1 |
| Auth Service (direto) | http://localhost:3001 |
| Profile Service (direto) | http://localhost:3002 |
| Feed Service (direto) | http://localhost:3003 |
| Messaging Service (direto) | http://localhost:3004 |
| PostgreSQL | localhost:5432 |
| Redis | localhost:6379 |
| MinIO Console | http://localhost:9001 |

### 2. App Mobile (Flutter)

```bash
# na raiz do projeto
flutter pub get

# configurar a URL da API em lib/core/config/app_config.dart:
# - Emulador Android: apiBaseUrl = 'http://10.0.2.2:3000/api/v1'
# - Chrome (web dev): apiBaseUrl = 'http://localhost:3000/api/v1'

flutter run
```

### 3. Rodando os testes

```bash
# testes do app mobile (Flutter)
flutter test

# testes de cada serviço do backend (ex: auth-service)
cd backend/auth-service
npm ci
npm run test
```

> Nota: no momento desta entrega, os serviços de backend têm o script `test` configurado (Jest), mas ainda não possuem arquivos `.spec.ts` implementados. O harness que já roda de fato é o do app Flutter, em `/test`.

---

## 🏛️ ADRs — Registro Sintético de Decisões Arquiteturais

| ADR | Decisão | Motivo |
|---|---|---|
| ADR-001 | Arquitetura de microsserviços com NestJS (gateway, auth, profile, feed, messaging) | Escalabilidade e isolamento de falhas por domínio de negócio |
| ADR-002 | Schema PostgreSQL isolado por serviço, sem joins cross-schema | Evitar acoplamento entre serviços via banco de dados |
| ADR-003 | Redis para armazenamento de código OTP | TTL nativo de 10 minutos, sem poluir o banco relacional com dados efêmeros |
| ADR-004 | Refresh token armazenado como hash bcrypt, com rotação a cada uso | Nunca guardar token em texto plano; reduzir impacto de um eventual vazamento de banco |
| ADR-005 | Paginação por cursor (base64 de timestamp) em vez de offset | Scroll infinito sem problemas de performance em grandes volumes |
| ADR-006 | Feed local priorizado, com "Exploração Forçada" de ≥20% de conteúdo de outras instituições no feed global | Sustentar a proposta do produto de reduzir o isolamento entre universidades |
| ADR-007 | Privacidade de perfil em 3 níveis (`public`, `local_only`, `private`) | Atender aos requisitos de produto e às exigências de proteção de dados (LGPD) |
| ADR-008 | Flutter com Clean Architecture no mobile (`core/data/domain/presentation`) | Separar domínio de infraestrutura, facilitando testes e manutenção |

*(Este quadro reúne, em formato de ADR, as decisões já registradas em `docs/guias/padroes-desenvolvimento.md`. Novas decisões devem ser adicionadas a esta tabela conforme o projeto evolui.)*

---

*Para diagramas, contratos de API e guias completos de desenvolvimento, consulte [`/docs/README.md`](./docs/README.md).*
