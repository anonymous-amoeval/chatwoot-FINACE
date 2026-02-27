# 📚 GPT Finance 本地开发 - 文件导航地图

## 文件树状结构

```
GPT finance/
│
├─ 📖 文档文件 (你应该读这些)
│  ├─ START_HERE.md                 ⭐ 【从这里开始】3分钟快速概览
│  ├─ DEPLOYMENT_GUIDE_CN.md        🇨🇳 详细中文部署指南（完整且详尽）
│  ├─ LOCAL_DEPLOYMENT_GUIDE.md     🇬🇧 英文部署指南
│  ├─ QUICK_START.md                ⚡ 快速参考和常见问题
│  └─ FILES_GUIDE.md                📍 这个文件（文件导航）
│
├─ 🚀 脚本文件 (一键执行)
│  ├─ setup_dev_env.ps1             自动配置虚拟环境和依赖【第1步运行】
│  ├─ setup_dev_env.bat             Windows批量脚本版本
│  ├─ setup_database.py             初始化数据库表【第2步运行】
│  ├─ run_api.ps1                   启动API服务器【第3步运行】
│  └─ SETUP_COMPLETE.ps1            显示完成总结
│
├─ 📦 虚拟环境
│  └─ venv/                         Python虚拟环境（自动创建）
│     ├─ Scripts/                   可执行程序
│     └─ Lib/site-packages/         安装的Python包
│
├─ 🔧 后端代码
│  ├─ backendAPI/gp/flaskback/
│  │  ├─ backend_api/
│  │  │  ├─ main.py                 ⭐ 【重要】Flask API主程序
│  │  │  ├─ compliance_tools.py      KYC验证和合规检查逻辑
│  │  │  ├─ database_test.py        数据库测试脚本
│  │  │  ├─ api_test.py             API测试脚本
│  │  │  ├─ tools_id_documents.py   证件识别工具
│  │  │  ├─ .env                    ⭐ 【重要】你的配置文件（API keys）
│  │  │  └─ __pycache__/           Python编译缓存
│  │  │
│  │  └─ webhook/
│  │     ├─ lambda_bot.py          聊天机器人集成
│  │     ├─ common_tools.py        通用工具函数
│  │     ├─ env.txt                依赖说明
│  │     ├─ layer/                 Lambda层文件
│  │     ├─ attachments/           附件存储
│  │     └─ __pycache__/           Python缓存
│  │
│  └─ webhook_common/              共享代码
│
├─ 🎨 前端代码 (Flutter)
│  └─ KYC面板/gpstatus/
│     ├─ lib/
│     │  ├─ main.dart              Flutter应用入口
│     │  ├─ app_constant.dart      常量定义
│     │  ├─ routes.dart            路由配置
│     │  ├─ controllers/           业务逻辑
│     │  ├─ helpers/               辅助函数
│     │  ├─ models/                数据模型
│     │  ├─ views/                 UI界面（页面）
│     │  └─ widgets/               UI组件（可重用）
│     ├─ pubspec.yaml              Flutter配置和依赖
│     ├─ web/                      Web版本资源
│     ├─ assets/                   静态资源（图片、语言等）
│     └─ build/                    编译输出目录
│
├─ 📄 配置和数据文件
│  ├─ README.txt                   项目概述和账户信息
│  ├─ Presentation1.pptx           演示文稿
│  └─ 相关文件/                    补充资料目录
│     ├─ gpt-files/                GPT训练数据（原始版本）
│     ├─ gpt-files-common/         GPT训练数据（通用版本）
│     ├─ gpt-files-latest/         GPT训练数据（最新版本）
│     ├─ gpt训练/                  训练相关文件
│     ├─ 反馈-0620/                反馈信息
│     ├─ 对话30/                   聊天记录
│     └─ Billing/                  账单信息
│
└─ 🔨 工具和缓存
   ├─ .idea/                       IDE配置（可忽略）
   ├─ .DS_Store                    macOS文件（可忽略）
   └─ __pycache__/                 Python缓存（可忽略）
```

---

## 按用途分类

### 🎯 初次部署时要用的文件

**顺序：**

1. **阅读**：`START_HERE.md` (3分钟)
2. **运行**：`setup_dev_env.ps1` (5分钟)
3. **编辑**：`backendAPI/gp/flaskback/backend_api/.env` (2分钟)
4. **运行**：`setup_database.py` (2分钟)
5. **运行**：`run_api.ps1` (启动服务)
6. **参考**：`DEPLOYMENT_GUIDE_CN.md` (遇到问题时)

### 📖 阅读材料（按详细程度）

| 文件 | 长度 | 详细度 | 最佳时机 |
|------|------|--------|---------|
| START_HERE.md | 3页 | ⭐ | 第一次开始 |
| QUICK_START.md | 4页 | ⭐⭐ | 日常开发参考 |
| DEPLOYMENT_GUIDE_CN.md | 12页 | ⭐⭐⭐⭐ | 详细了解或遇到问题 |
| LOCAL_DEPLOYMENT_GUIDE.md | 10页 | ⭐⭐⭐⭐ | 英文版本 |

### 🔧 要编辑的主要文件

#### 必编辑
- **`backendAPI/gp/flaskback/backend_api/.env`**
  - 添加你的 OpenAI API Key
  - 修改数据库配置（如使用不同的主机）

#### 可能编辑（开发新功能）
- **`backendAPI/gp/flaskback/backend_api/main.py`**
  - 添加新的 API endpoint
  - 修改路由逻辑
  
- **`backendAPI/gp/flaskback/backend_api/compliance_tools.py`**
  - 修改 KYC 验证规则
  - 添加新的合规检查

- **`backendAPI/gp/flaskback/webhook/lambda_bot.py`**
  - 修改聊天机器人回应
  - 添加新的聊天命令

### 📦 Python 文件说明

| 文件 | 用途 | 依赖 |
|------|------|------|
| main.py | Flask API服务器 | Flask, PyMySQL |
| compliance_tools.py | KYC验证逻辑 | OpenAI, requests |
| lambda_bot.py | AI聊天机器人 | OpenAI, requests |
| common_tools.py | 共享工具函数 | requests |
| database_test.py | 测试数据库连接 | PyMySQL |
| api_test.py | 测试API端点 | requests |
| tools_id_documents.py | 证件识别 | OpenAI |

### 🎨 Flutter 文件说明

| 目录 | 文件 | 说明 |
|------|------|------|
| lib/ | main.dart | 应用程序入口 |
| lib/controllers/ | \*.dart | 业务逻辑（处理数据和状态） |
| lib/models/ | \*.dart | 数据结构定义 |
| lib/views/ | \*.dart | 完整的应用页面 |
| lib/widgets/ | \*.dart | 可重用的UI组件 |
| assets/images/ | \*.png/jpg | 图片资源 |
| assets/lang/ | \*.json | 多国语言支持 |

---

## 关键文件详解

### 1. `.env` 文件

**位置**：`backendAPI/gp/flaskback/backend_api/.env`

**内容**（示例）：
```env
OPENAI_API_KEY=sk-你的真实密钥
DB_HOST=127.0.0.1
DB_USER=gp_data
DB_PASSWORD=jizbpLWSCSB5Jpyr
DB_NAME=gp_data
CHATWOOT_URL=https://...
CHATWOOT_BOT_TOKEN=...
```

**重要**：
- ⚠️ 包含敏感信息，不要上传到 Git
- 每台机器都需要自己的 .env（会自动生成模板）
- 修改后需要重启 Flask 才能读取新值

### 2. `main.py` 文件

**位置**：`backendAPI/gp/flaskback/backend_api/main.py`

**作用**：
- 定义所有 API 端点（routes）
- 处理数据库连接
- 返回 JSON 响应

**主要内容**：
```python
@app.route('/getallkycstatus', methods=['POST', 'GET'])
def get_kyc_status():
    # 获取所有KYC数据
    ...

@app.route('/init_kyc_data', methods=['POST'])
def init_kyc_data():
    # 初始化新用户KYC
    ...
```

**如何修改**：
1. 在 main.py 中添加新的 `@app.route()` 函数
2. 保存文件（Flask 自动重启）
3. 通过 `curl` 或浏览器测试

### 3. `compliance_tools.py` 文件

**位置**：`backendAPI/gp/flaskback/backend_api/compliance_tools.py`

**作用**：
- KYC / 合规检查逻辑
- 调用 OpenAI 分析识别和搜索结果
- 集成各种验证工具

**主要工具**：
- `query_member_check()` - 成员身份检查
- `query_google_search()` - Google 搜索
- `query_baidu_search()` - 百度搜索
- `query_tianyancha()` - 天眼查（中文企业查询）

### 4. `lambda_bot.py` 文件

**位置**：`backendAPI/gp/flaskback/webhook/lambda_bot.py`

**作用**：
- 集成 Chatwoot 聊天系统
- 调用 OpenAI Assistant
- 处理用户消息和回复

**连接流程**：
```
Chatwoot → webhook → lambda_bot.py → OpenAI → 回复用户
```

---

## 常见任务的文件位置

### 我想...

| 任务 | 打开文件 | 说明 |
|------|---------|------|
| 添加 API key | `.env` | 在 OPENAI_API_KEY 后面粘贴 |
| 创建新 API | `main.py` | 添加新的 @app.route 函数 |
| 改 KYC 规则 | `compliance_tools.py` | 修改验证逻辑 |
| 测试数据库 | `database_test.py` | 运行后看输出 |
| 修改聊天回复 | `lambda_bot.py` | 修改机器人提示词 |
| 看演示幻灯片 | `Presentation1.pptx` | 用 PowerPoint 打开 |
| 查看数据表设计 | `README.txt` | 第一部分"聊天表"说明 |
| 获取聊天账户 | `README.txt` | 找 Chatwoot 部分 |
| 改 Flutter UI | `KYC面板/gpstatus/lib/` | 修改对应的 .dart 文件 |

---

## 🔒 安全提示

### 不应该做的

❌ **永远不要**：
- 将 `.env` 文件上传到 GitHub
- 分享你的 OpenAI API Key
- 在代码中硬编码密码（应该用 .env）
- 在 README 中记录真实的密钥

✅ **应该做的**：
- 在 `.gitignore` 中排除 `.env`
- 定期轮换 API Keys
- 使用环境变量而不是硬编码
- 备份 `.env` 文件到安全位置

### 检查清单

在提交代码前：
- [ ] `.env` 未添加到 Git
- [ ] 代码中没有硬编码的密钥
- [ ] `.gitignore` 包含 `*.env`
- [ ] 没有上传个人账户信息

---

## 📞 文件关系图

```
用户请求
  ↓
run_api.ps1
  ↓
main.py (Flask)
  ├→ .env (配置)
  ├→ compliance_tools.py (KYC逻辑)
  └→ database (MySQL)
       ↓
    setup_database.py (初始化)
```

---

## 大小参考

| 文件/文件夹 | 大小 | 说明 |
|------------|------|------|
| venv/ | ~300MB | 虚拟环境（可直接删除） |
| backendAPI/ | ~20MB | 后端代码 |
| KYC面板/ | ~50MB | Flutter 项目 |
| 相关文件/ | ~100MB | 数据和文档 |
| **总计** | **~500MB** | 完整项目 |

---

## 下一步

现在你知道了每个文件的作用，可以：

1. **快速开始**：打开 `START_HERE.md`
2. **深入学习**：看 `DEPLOYMENT_GUIDE_CN.md`
3. **日常参考**：用 `QUICK_START.md`
4. **遇到问题**：搜索文件中的故障排除部分

祝你开发顺利！🚀
