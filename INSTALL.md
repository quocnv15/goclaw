# 🚀 GoClaw — Hướng Dẫn Cài Đặt Từng Bước (macOS)

> Đã kiểm tra trên máy hiện tại: Go 1.26, Docker 28.3, Docker Compose v2.39, Node v22, Apple Silicon.

---

## Tổng Quan

GoClaw chạy bằng **Docker Compose** gồm 3 container:
1. **goclaw** — Go gateway binary (~25MB)
2. **postgres** — PostgreSQL 18 + pgvector (multi-tenant storage)
3. **goclaw-ui** — React SPA web dashboard (nginx)

**Thời gian cài đặt:** ~10-15 phút (bao gồm Docker build lần đầu)

---

## Step 1: Mở Docker Desktop

```bash
open -a Docker
```

Đợi Docker icon ở menu bar chuyển sang **xanh** (running), khoảng 10-30 giây.

**Kiểm tra:**
```bash
docker info | head -5
# Phải thấy: "Server Version: ..."
```

---

## Step 2: Tạo file `.env` với secrets tự động

```bash
cd /Volumes/Workspace/0-Working/agents/goclaw
chmod +x prepare-env.sh
./prepare-env.sh
```

Script sẽ:
- Tạo `.env` từ `.env.example`
- Tự sinh `GOCLAW_ENCRYPTION_KEY` (AES-256-GCM)
- Tự sinh `GOCLAW_GATEWAY_TOKEN` (API auth)

**Kiểm tra:**
```bash
cat .env
# Phải thấy GOCLAW_ENCRYPTION_KEY=<hex> và GOCLAW_GATEWAY_TOKEN=<hex>
```

---

## Step 3: Thêm LLM API Key

Mở `.env` và thêm **ít nhất 1** API key. Chọn provider bạn có:

### Option A: OpenRouter (khuyến nghị — truy cập nhiều model)
```bash
echo 'GOCLAW_OPENROUTER_API_KEY=sk-or-v1-xxx' >> .env
```

### Option B: Google Gemini (có free tier)
```bash
echo 'GOCLAW_GEMINI_API_KEY=xxx' >> .env
```

### Option C: Anthropic Claude
```bash
echo 'GOCLAW_ANTHROPIC_API_KEY=sk-ant-xxx' >> .env
```

### Option D: OpenAI
```bash
echo 'GOCLAW_OPENAI_API_KEY=sk-xxx' >> .env
```

> 💡 **Lấy key ở đâu?**
> - OpenRouter: https://openrouter.ai/keys
> - Gemini: https://aistudio.google.com/apikey
> - Anthropic: https://console.anthropic.com/settings/keys
> - OpenAI: https://platform.openai.com/api-keys

---

## Step 4: Tạo Docker network

```bash
docker network inspect shared >/dev/null 2>&1 || docker network create shared
```

---

## Step 5: Build & Deploy

```bash
make up
```

Lệnh này tương đương:
```bash
docker compose -f docker-compose.yml \
  -f docker-compose.postgres.yml \
  -f docker-compose.selfservice.yml up -d --build

docker compose -f docker-compose.yml \
  -f docker-compose.postgres.yml \
  -f docker-compose.upgrade.yml run --rm upgrade
```

> ⏱️ **Lần đầu build:** ~5-10 phút (pull images + compile Go binary + build React SPA)
> Các lần sau: ~30 giây (cached layers)

---

## Step 6: Kiểm Tra

### 6a. Kiểm tra containers đang chạy
```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Phải thấy 3 containers: `goclaw`, `postgres`, `goclaw-ui` — tất cả `Up`.

### 6b. Kiểm tra health
```bash
curl http://localhost:18790/health
```

Phải trả về response OK.

### 6c. Mở Web Dashboard
```bash
open http://localhost:3000
```

---

## Step 7: Cấu Hình Agent Đầu Tiên (Web Dashboard)

1. Mở `http://localhost:3000`
2. Dashboard sẽ tự auto-onboard (detect API key → tạo default agent)
3. Bạn có thể chat thử với agent ngay trên dashboard

---

## 🛠️ Lệnh Quản Lý Hàng Ngày

| Lệnh | Mô tả |
|---|---|
| `make up` | Start/rebuild tất cả |
| `make down` | Stop tất cả |
| `make logs` | Xem logs real-time |
| `make reset` | Xoá data + deploy lại từ đầu |
| `docker compose ... logs -f postgres` | Xem logs PostgreSQL |

---

## ⚠️ Troubleshooting

### Docker daemon chưa chạy
```
Cannot connect to the Docker daemon...
```
→ Mở Docker Desktop: `open -a Docker`

### Port conflict
```
Bind for 0.0.0.0:5432 failed: port is already allocated
```
→ Thêm vào `.env`: `POSTGRES_PORT=5433`

### Build fails
```bash
# Xem logs chi tiết
docker compose -f docker-compose.yml -f docker-compose.postgres.yml -f docker-compose.selfservice.yml logs --tail 50
```

### Reset hoàn toàn
```bash
make reset
# Xoá toàn bộ volumes (DB data) và build lại
```
