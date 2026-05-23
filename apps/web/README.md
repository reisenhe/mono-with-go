# Web 前端

Mono With Go 项目的前端应用，基于 React + TypeScript + Tailwind CSS 构建。

## 技术栈

| 技术                                          | 版本 | 说明                  |
| --------------------------------------------- | ---- | --------------------- |
| [React](https://react.dev/)                   | 19   | UI 框架               |
| [TypeScript](https://www.typescriptlang.org/) | 6    | 类型安全              |
| [Vite](https://vite.dev/)                     | 8    | 构建工具 & 开发服务器 |
| [Tailwind CSS](https://tailwindcss.com/)      | 4    | 原子化 CSS 框架       |
| [ESLint](https://eslint.org/)                 | 10   | 代码规范检查          |

## 目录结构

```
web/
├── public/              # 静态资源
├── src/
│   ├── assets/          # 图片等资源文件
│   ├── App.tsx          # 主应用组件
│   ├── App.css          # 自定义样式（非 Tailwind 场景）
│   ├── index.css        # Tailwind 入口
│   └── main.tsx         # 应用入口
├── index.html           # HTML 模板
├── vite.config.ts       # Vite 配置
├── tsconfig.json        # TypeScript 配置
├── eslint.config.js     # ESLint 配置
└── package.json
```

## 开发

```bash
# 在项目根目录执行（推荐）
pnpm dev:web

# 或在本目录执行
pnpm dev
```

开发服务器启动在 **http://localhost:3000**。

### API 代理

`vite.config.ts` 中配置了代理规则，所有 `/api` 开头的请求自动转发到后端服务：

```typescript
proxy: {
  '/api': {
    target: 'http://localhost:8080',
    changeOrigin: true,
  },
}
```

前端代码中直接使用相对路径调用接口：

```typescript
const res = await fetch("/api/health");
```

## 构建

```bash
# 在项目根目录执行
pnpm build:web

# 或在本目录执行
pnpm build
```

构建产物输出到 `dist/` 目录。

## 代码规范

```bash
pnpm lint
```

## 样式方案

项目使用 **Tailwind CSS 4**，通过 Vite 插件集成（零配置）：

- 入口文件 `src/index.css` 中引入 `@import "tailwindcss"`
- 直接在 JSX 中使用 Tailwind class
- 如需自定义样式，可在 `App.css` 中编写

```tsx
<div className="flex items-center gap-4 bg-white rounded-lg shadow p-6">
  <h1 className="text-2xl font-bold text-gray-900">Hello</h1>
</div>
```
