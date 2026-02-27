# 🚀 GPT Finance 本地PC部署完整中文指南

> 这是为初次接触这个项目的人准备的详细中文教程

## 概述

你现在有一个完整的、可以在本地PC运行的财务聊天系统。它包括：

- **后端API服务**：处理数据、用户认证、KYC流程
- **数据库**：存储用户信息、订单、认证结果
- **AI聊天机器人**：使用OpenAI接口的智能客服
- **聊天系统集成**：与Chatwoot通讯平台连接

## 为什么用虚拟环境？

Python虚拟环境就像Windows的"沙箱"。它的好处：

| 好处 | 说明 |
|------|------|
| **隔离** | 这个项目的包不会影响你电脑其他Python项目 |
| **干净** | 卸载时直接删除 venv 文件夹就完全干净 |
| **安全** | 不同项目版本冲突了也不会影响系统 |
| **易管理** | 清楚知道这个项目用了什么包 |

### 类比
虚拟环境 ≈ 虚拟机，但是轻量级的（只隔离Python，不隔离整个系统）

---

## 📋 完整步骤（一步步做）

### 步骤1️⃣：验证自动设置成功

脚本已经运行过了。检查是否成功：

```powershell
# 在项目根目录打开 PowerShell

# 看看虚拟环境是否创建了
dir venv

# 看看 .env 文件是否创建了
dir backendAPI\gp\flaskback\backend_api\.env

# 应该都看到文件
```

### 步骤2️⃣：关键第一步 - 获取 OpenAI API Key

这是必须的，没有这个API key无法使用AI功能。

**获取步骤：**

1. **打开网址**
   ```
   https://platform.openai.com/api-keys
   ```

2. **登录或注册账号**
   - 你需要一个 OpenAI 账户
   - （可以用Google的邮箱快速登录）

3. **创建新API Key**
   - 点击 "Create new secret key"
   - 给它起个名字，比如 "Local Development"
   - 复制生成的密钥

4. **把密钥存到 `.env` 文件**
   
   打开这个文件：
   ```
   backendAPI\gp\flaskback\backend_api\.env
   ```
   
   找到这一行：
   ```env
   OPENAI_API_KEY=sk-your-actual-key-here
   ```
   
   替换成你的真实密钥：
   ```env
   OPENAI_API_KEY=sk-你刚复制的密钥
   ```
   
   **例子：**
   ```env
   OPENAI_API_KEY=sk-ABd8bsh9K9IFG6HERiY5T3BlbkFJ4Xpq4Nn5TI5nemm
   ```

5. **保存文件**

**⚠️ 重要安全提示：**
- 这个密钥相当于你的密码，别分享给任何人
- 别上传到 GitHub（`.gitignore` 里已经排除了）
- 如果不小心泄露，立即在 OpenAI 网站删除这个密钥

---

### 步骤3️⃣：启动数据库（MySQL）

项目需要一个数据库来存储数据。有两个选择：

**选项 A：用 Docker 启动（推荐，更简单）**

如果你装了Docker Desktop：

```powershell
docker run --name gp-mysql `
  -e MYSQL_ROOT_PASSWORD=root123 `
  -e MYSQL_DATABASE=gp_data `
  -p 3306:3306 `
  -d mysql:8.0
```

**这是什么意思：**
- `docker run` = 创建并运行一个容器
- `--name gp-mysql` = 容器名字（方便识别）
- `-e MYSQL_ROOT_PASSWORD=root123` = root用户密码
- `-e MYSQL_DATABASE=gp_data` = 预先创建"gp_data"数据库
- `-p 3306:3306` = 映射端口（MySQL默认3306）
- `-d` = 后台运行
- `mysql:8.0` = 使用MySQL 8.0版本

**验证是否成功：**
```powershell
# 看看容器是否运行了
docker ps

# 应该看到 gp-mysql 在列表里
```

**选项 B：本地安装 MySQL（如没有Docker）**

1. 下载：https://dev.mysql.com/downloads/mysql/
2. 安装程序，记住root密码
3. 创建用户和数据库：

```powershell
# 连接到 MySQL
mysql -u root -p
# 输入密码

# 在 MySQL 命令行中执行以下命令：
CREATE DATABASE gp_data;
CREATE USER 'gp_data'@'localhost' IDENTIFIED BY 'jizbpLWSCSB5Jpyr';
GRANT ALL PRIVILEGES ON gp_data.* TO 'gp_data'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

### 步骤4️⃣：初始化数据库表

这一步创建项目所需的数据表。

```powershell
# 确保在项目根目录
cd "C:\Users\92312\Downloads\GPT finance\GPT finance"

# 运行初始化脚本
python setup_database.py
```

**成功的输出应该看起来像：**
```
============================================================
GPT Finance Database Initialization
============================================================

Database connection info:
   Host: 127.0.0.1:3306
   User: gp_data
   Database: gp_data

Connecting to database...
OK Database connection successful

Creating database tables...
------------------------------------------------------------
OK Table 'kyc_data' created/exists
OK Table 'chat_messages' created/exists
OK Table 'users' created/exists
OK Table 'orders' created/exists
------------------------------------------------------------

============================================================
OK Database initialization complete!
============================================================

Tables created:
   • kyc_data
   • chat_messages
   • users
   • orders

Next you can run:
   python -m flask --app backend_api.main run --debug
```

如果看到错误，查看下面的【故障排除】部分。

---

### 步骤5️⃣：启动 API 服务器

现在开始运行后端API！

**方式A：用快速启动脚本（推荐）**

```powershell
# 在项目根目录
cd "C:\Users\92312\Downloads\GPT finance\GPT finance"

# 运行脚本
.\run_api.ps1
```

**方式B：手动启动**

```powershell
# 激活虚拟环境
.\venv\Scripts\Activate.ps1

# 进入后端目录
cd backendAPI\gp\flaskback

# 启动服务
python -m flask --app backend_api.main run --debug
```

**成功的输出：**
```
 * Serving Flask app 'backend_api.main'
 * Debug mode: on
 * Running on http://127.0.0.1:5000
 * Press CTRL+C to quit
```

✅ **现在你的 API 服务运行在 http://localhost:5000**

---

### 步骤6️⃣：测试 API

打开**另一个** PowerShell 窗口（不要关闭运行中的Flask）：

```powershell
# 测试 API 是否响应
curl http://localhost:5000/getallkycstatus
```

**可能的结果：**

**成功**：返回 JSON 数据（空数组或数据）
```json
[]
```

**数据库连接问题**：
```
Internal Server Error
```
→ 检查 MySQL 是否运行

**API不存在**：
```
404 Not Found
```
→ Flask 可能没启动，或端口不对

---

## 🛑 常见问题 & 解决方案

### 问题1：虚拟环境激活失败
```
PowerShell 执行策略问题
```

**解决：**
```powershell
# 允许执行脚本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 然后重新激活
.\venv\Scripts\Activate.ps1
```

### 问题2：ModuleNotFoundError: No module named 'flask'
```
找不到 Flask 模块
```

**原因**：虚拟环境没激活

**确认激活：**
```powershell
# 命令提示符前面应该看到 (venv)
# 如果没有，运行:
.\venv\Scripts\Activate.ps1
```

### 问题3："Can't connect to MySQL server"
```
数据库连接失败
```

**检查清单：**

1. **Docker 用户**：检查容器是否还在运行
   ```powershell
   docker ps
   # 如果没看到 gp-mysql，重新启动:
   docker start gp-mysql
   ```

2. **本地 MySQL 用户**：检查服务是否启动
   ```powershell
   # Windows 任务管理器 → 服务 → 找 MySQL 服务并启动
   # 或在 MySQL Workbench 中连接
   ```

3. **测试连接**：
   ```powershell
   # 如果有 MySQL 命令行工具
   mysql -h 127.0.0.1 -u gp_data -p
   # 输入密码: jizbpLWSCSB5Jpyr
   ```

### 问题4：OpenAI API 错误
```
Incorrect API key provided
```

**检查：**

1. API key 是否正确复制到 `.env` 文件
2. 文件是否保存了
3. Flask 是否重启了（重启才能读取新的 .env）

### 问题5：端口 5000 已被占用
```
Address already in use
```

**原因**：已有其他程序在用 5000 端口

**解决1**：杀死占用端口的进程
```powershell
# 找出占用 5000 的进程
netstat -ano | findstr :5000

# 杀死进程 (XXXX 是 PID)
taskkill /PID XXXX /F
```

**解决2**：用其他端口
```powershell
python -m flask --app backend_api.main run --debug --port 5001
```

### 问题6：数据库初始化失败
```
Error: Access denied for user 'gp_data'@'localhost'
```

**可能原因**：
1. MySQL 没启动
2. 用户名/密码错误
3. 用户未创建

**检查：**
```powershell
# 以 root 连接
mysql -u root -p

# 查看用户是否存在
SELECT user FROM mysql.user;

# 如果 gp_data 不在，创建它：
CREATE USER 'gp_data'@'localhost' IDENTIFIED BY 'jizbpLWSCSB5Jpyr';
GRANT ALL PRIVILEGES ON gp_data.* TO 'gp_data'@'localhost';
FLUSH PRIVILEGES;
```

---

## 📁 项目结构解释

```
GPT finance/
│
├── README.txt                    ← 项目概览
├── LOCAL_DEPLOYMENT_GUIDE.md     ← 详细部署指南
├── QUICK_START.md                ← 快速参考
├── THIS_FILE.md                  ← 你在看这个
│
├── setup_dev_env.ps1             ← 自动配置脚本 ✨
├── setup_database.py             ← 数据库初始化脚本
├── run_api.ps1                   ← 快速启动脚本
│
├── venv/                         ← 虚拟环境（安装的包都在这）
│   └── Lib\site-packages\        ← 所有 Python 包
│
├── backendAPI/
│   └── gp/
│       └── flaskback/
│           ├── backend_api/
│           │   ├── main.py       ← 🔑 API 主程序（重要！）
│           │   ├── compliance_tools.py   ← KYC 验证逻辑
│           │   ├── database_test.py      ← 数据库测试
│           │   └── .env          ← 🔑 你的配置文件（API key在这）
│           │
│           └── webhook/
│               ├── lambda_bot.py  ← 聊天机器人集成
│               ├── common_tools.py ← 通用工具函数
│               └── env.txt        ← 依赖说明
│
├── KYC面板/
│   └── gpstatus/
│       ├── lib/
│       │   ├── main.dart         ← Flutter 应用入口
│       │   └── ...
│       └── pubspec.yaml          ← Flutter 配置
│
└── 相关文件/
    ├── gpt-files/               ← GPT 训练数据
    ├── gpt-files-latest/        ← 最新版本数据
    └── ...
```

### 重点文件说明

| 文件 | 用途 | 何时修改 |
|------|------|---------|
| `.env` | 存放 API keys 和配置 | 每次从头开始都要改一遍API key |
| `main.py` | Flask API 主程序 | 开发新功能时修改 |
| `compliance_tools.py` | KYC/合规检查逻辑 | 修改验证规则时 |
| `lambda_bot.py` | 聊天机器人 | 修改机器人回应时 |

---

## 🎯 下一步可以做什么？

### 1️⃣ 探索 API

```powershell
# API 已在 http://localhost:5000 运行

# 查看所有 API 端点（搜索代码中的 @app.route）
grep -r "@app.route" backendAPI\gp\flaskback\

# 常用端点：
# GET  /getallkycstatus       - 获取所有 KYC 数据
# POST /init_kyc_data          - 初始化新用户 KYC
# ...（查看代码了解更多）
```

### 2️⃣ 修改代码和测试

由于 Flask 开启了 `--debug` 模式，修改 Python 代码后自动重启服务：

1. 在 VS Code 中修改 `main.py` 或其他 `.py` 文件
2. 保存文件
3. Flask 自动重启
4. 刷新浏览器或重新 curl 命令

### 3️⃣ 连接 Chatwoot 聊天系统

项目已集成 Chatwoot。如果想测试完整的聊天功能：

```env
# .env 文件中的这些配置已经指向测试环境
CHATWOOT_URL=https://chatwootgp-c6fd041db72e.herokuapp.com
CHATWOOT_BOT_TOKEN=BxjuXQJ4PTkPuUsMctrcKTBc
```

可以在这个网址访问：https://chatwootgp-c6fd041db72e.herokuapp.com

测试账号：
- 邮箱：testaccount@gp.com
- 密码：Aa223344!

### 4️⃣ 构建 Flutter 前端（可选）

如果想运行 Flutter 应用（KYC面板）：

```powershell
# 需要先安装 Flutter SDK
# 下载：https://flutter.dev/docs/get-started/install

# 然后在项目目录
cd "KYC面板\gpstatus"
flutter pub get
flutter run
```

但这对于测试后端API不是必需的。

---

## ✅ 成功标志

当你看到以下情况，说明部署成功了：

- ✅ `setup_dev_env.ps1` 完成，没有错误
- ✅ `setup_database.py` 完成，所有表创建成功
- ✅ Flask 服务启动，显示 "Running on http://127.0.0.1:5000"
- ✅ `curl http://localhost:5000/getallkycstatus` 返回 JSON（即使是 `[]`）
- ✅ `.env` 文件中有真实的 OpenAI API key

---

## 🧹 完全清除（重新开始）

如果想完全清除重新开始：

```powershell
# 删除虚拟环境（释放磁盘空间）
Remove-Item -Recurse -Force venv

# 删除生成的 .env 文件
Remove-Item backendAPI\gp\flaskback\backend_api\.env

# 删除数据库（Docker）
docker stop gp-mysql
docker rm gp-mysql

# 现在可以重新运行 setup_dev_env.ps1 重新开始
```

---

## 📞 需要帮助？

### 检查清单：

- [ ] Python 已安装且版本 3.7+
- [ ] 虚拟环境已创建 (看得到 venv 文件夹)
- [ ] 依赖包已安装 (`pip list` 能看到 flask, pymysql 等)
- [ ] `.env` 文件存在且有真实的 API key
- [ ] MySQL 数据库正在运行
- [ ] 数据库表已创建 (`python setup_database.py` 成功)
- [ ] Flask 服务已启动在 http://localhost:5000

### 查看日志：

```powershell
# Flask 的日志输出会直接显示在运行窗口
# 数据库错误会有 pymysql 错误信息
# 缺少包会有 ModuleNotFoundError

# 如果需要查看详细日志，可以修改代码：
# 在 main.py 中添加 print() 语句
# 或在错误处添加 try/except 捕获异常
```

---

## 🎓 学习资源

- **Flask 文档**：https://flask.palletsprojects.com/
- **OpenAI API**：https://platform.openai.com/docs/api-reference
- **MySQL 基础**：https://dev.mysql.com/doc/
- **虚拟环境**：https://docs.python.org/3/library/venv.html

---

## 总结

现在你有了：

1. ✅ 一个隔离的 Python 虚拟环境（不污染系统）
2. ✅ 安装好的所有必需包
3. ✅ 配置好的 MySQL 数据库
4. ✅ 运行中的 Flask API 服务
5. ✅ 可以测试和修改的代码

**享受开发！🎉**

如有问题，查看【常见问题 & 解决方案】部分。
