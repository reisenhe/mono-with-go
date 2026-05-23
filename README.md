# Mono With Go

一个基于 **React + Go** 的全栈 Monorepo 项目模板，使用 Docker 容器化开发，开箱即用。

## 特性

- **Monorepo 架构** — pnpm workspaces 统一管理前后端
- **容器化开发** — Go 后端运行在 Docker 中，无需本地安装 Go 环境
- **热重载** — 前端 Vite HMR + 后端 Air 自动重编译
- **一键启停** — `pnpm start:all` / `pnpm stop:all` 管理完整开发环境
- **JWT 认证** — 开箱即用的注册/登录/鉴权流程
- **数据库** — PostgreSQL，通过 Docker Compose 自动管理

## 技术栈

| 层级   | 技术                                          |
| ------ | --------------------------------------------- |
| 前端   | React 19 · TypeScript · Vite · Tailwind CSS 4 |
| 后端   | Go 1.23 · Gin · GORM · JWT                    |
| 数据库 | PostgreSQL 16                                 |
| 基建   | pnpm · Docker · Docker Compose                |

## 项目结构

```
mono-with-go/
├── apps/
│   ├── web/                 # 前端应用
│   │   ├── src/
│   │   ├── vite.config.ts   # Vite 配置（含 API 代理）
│   │   └── package.json
│   └── api-go/              # 后端服务
│       ├── config/          # 数据库 & JWT 配置
│       ├── handler/         # 路由处理器
│       ├── middleware/      # JWT 鉴权 & CORS 中间件
│       ├── model/           # 数据模型
│       ├── router/          # 路由注册
│       ├── Dockerfile       # 容器构建
│       ├── entrypoint.sh    # 容器入口脚本
│       └── main.go          # 入口文件
├── scripts/
│   ├── start-all.ps1        # 一键启动（含 Docker 检查）
│   └── stop-all.ps1         # 一键停止
├── docker-compose.yml       # Docker 编排
├── pnpm-workspace.yaml      # 工作空间配置
└── package.json             # 根脚本入口
```

## 快速开始

### 前置要求

- [Node.js](https://nodejs.org/) >= 18
- [pnpm](https://pnpm.io/) >= 8
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

> **无需安装 Go！** 后端完全在 Docker 容器中运行。

### 安装依赖

```bash
# 安装前端依赖
pnpm install
```

### 启动开发环境

```bash
# 一键启动（自动检查 Docker Desktop → 启动后端容器 → 启动前端）
pnpm start:all

# 或分别启动
pnpm dev:web          # 前端：http://localhost:3000
pnpm dev:api:build    # 后端：http://localhost:8080（首次需 build）
```

### 停止开发环境

```bash
pnpm stop:all
```

### 其他命令

```bash
pnpm dev              # 前后端同时启动（前台模式）
pnpm build:web        # 构建前端生产包
pnpm docker:logs      # 查看后端容器日志
```

## API 接口

| 方法 | 路径            | 说明                 | 鉴权 |
| ---- | --------------- | -------------------- | ---- |
| GET  | `/api/health`   | 健康检查             | 否   |
| POST | `/api/register` | 用户注册             | 否   |
| POST | `/api/login`    | 用户登录（返回 JWT） | 否   |
| GET  | `/api/profile`  | 获取用户信息         | 是   |

### 请求示例

```bash
# 注册
curl -X POST http://localhost:8080/api/register \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"123456","email":"demo@example.com"}'

# 登录
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"123456"}'

# 访问受保护接口
curl http://localhost:8080/api/profile \
  -H "Authorization: Bearer <your-token>"
```

## 开发指南

### 后端开发

后端代码修改后 **自动热重载**（由 [Air](https://github.com/air-verse/air) 监听文件变更）。

关键目录：

- `handler/` — 编写新的接口处理逻辑
- `model/` — 定义数据模型（GORM 自动迁移）
- `middleware/` — 添加中间件
- `router/` — 注册路由

### 前端开发

前端使用 Vite 开发服务器，支持 HMR。API 请求通过 `vite.config.ts` 中的 proxy 自动转发到后端 `:8080`。

### 环境变量

后端容器环境变量在 `docker-compose.yml` 中配置：

| 变量          | 说明         | 默认值                                 |
| ------------- | ------------ | -------------------------------------- |
| `DB_HOST`     | 数据库主机   | `postgres`                             |
| `DB_PORT`     | 数据库端口   | `5432`                                 |
| `DB_USER`     | 数据库用户   | `postgres`                             |
| `DB_PASSWORD` | 数据库密码   | `postgres`                             |
| `DB_NAME`     | 数据库名     | `mono_dev`                             |
| `JWT_SECRET`  | JWT 签名密钥 | `your-secret-key-change-in-production` |
| `GIN_MODE`    | Gin 运行模式 | `debug`                                |

## 许可证

[MIT](./LICENSE)
