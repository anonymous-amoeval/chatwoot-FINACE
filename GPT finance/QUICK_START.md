# 🚀 GPT Finance 本地开发 - 快速参考

## ⚡ 5分钟快速开始

```powershell
# 1. 运行自动设置脚本
.\setup_dev_env.ps1

# 2. 编辑 .env 文件，添加你的 OpenAI API key
# 位置: backendAPI\gp\flaskback\backend_api\.env

# 3. 启动 MySQL (如果没运行)
docker run --name gp-mysql -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=gp_data -p 3306:3306 -d mysql:8.0

# 4. 初始化数据库
python setup_database.py

# 5. 启动 API 服务器
.\run_api.ps1
```

---

## 📚 完整步骤详解

### 第1步：准备虚拟环境
```powershell
# 仅第一次需要运行
.\setup_dev_env.ps1
```

**这个脚本会：**
- ✅ 检查 Python 是否安装
- ✅ 创建虚拟环境 (venv)
- ✅ 安装所有 Python 依赖
- ✅ 生成 .env 配置文件模板

### 第2步：配置 API 密钥

编辑文件: `backendAPI\gp\flaskback\backend_api\.env`

```env
# 必须设置！从这里获取: https://platform.openai.com/api-keys
OPENAI_API_KEY=sk-your-actual-key-here

# 其他配置（通常不需要改）
DB_HOST=127.0.0.1
DB_USER=gp_data
DB_PASSWORD=jizbpLWSCSB5Jpyr
DB_NAME=gp_data
```

### 第3步：启动数据库

**选项 A: 用 Docker (推荐)**
```powershell
docker run --name gp-mysql `
  -e MYSQL_ROOT_PASSWORD=root123 `
  -e MYSQL_DATABASE=gp_data `
  -p 3306:3306 `
  -d mysql:8.0
```

**选项 B: 本地 MySQL**
```powershell
# 确保 MySQL 服务已启动
mysql -u root -p

# 在 MySQL 中执行
CREATE DATABASE gp_data;
CREATE USER 'gp_data'@'localhost' IDENTIFIED BY 'jizbpLWSCSB5Jpyr';
GRANT ALL PRIVILEGES ON gp_data.* TO 'gp_data'@'localhost';
FLUSH PRIVILEGES;
```

### 第4步：初始化数据库表

```powershell
# 第一次运行创建表
python setup_database.py

# 成功后应显示:
# ✅ 数据库初始化完成！
# 已创建的表:
#    • kyc_data
#    • chat_messages
#    • users
#    • orders
```

### 第5步：启动 API 服务器

```powershell
# 简单方式（推荐）
.\run_api.ps1

# 或手动方式
.\venv\Scripts\Activate.ps1
cd backendAPI\gp\flaskback
python -m flask --app backend_api.main run --debug
```

**成功的输出：**
```
 * Serving Flask app 'backend_api.main'
 * Debug mode: on
 * Running on http://127.0.0.1:5000
```

### 第6步：测试 API

在**新的 PowerShell 窗口**运行：

```powershell
# 测试 KYC 状态接口
curl http://localhost:5000/getallkycstatus

# 应该返回 JSON 数据 (或空数组 [])
# 如果显示错误，检查数据库是否已启动
```

---

## 🛠️ 常用命令

| 任务 | 命令 |
|------|------|
| 激活虚拟环境 | `.\venv\Scripts\Activate.ps1` |
| 停用虚拟环境 | `deactivate` |
| 查看已安装包 | `pip list` |
| 安装新包 | `pip install package_name` |
| 启动 API 服务 | `.\run_api.ps1` |
| 初始化数据库 | `python setup_database.py` |
| 连接 MySQL | `mysql -u gp_data -p` (密码: jizbpLWSCSB5Jpyr) |
| 检查 MySQL 容器 | `docker ps` |
| 停止数据库 | `docker stop gp-mysql` |
| 启动数据库 | `docker start gp-mysql` |
| 重建虚拟环境 | `Remove-Item -Recurse -Force venv` 然后运行 setup_dev_env.ps1 |

---

## 📂 重要文件位置

```
GPT finance/
├── setup_dev_env.ps1           ← 自动配置脚本
├── setup_database.py            ← 初始化数据库脚本
├── run_api.ps1                  ← 快速启动脚本
├── .env                         ← 环境变量（保密！）
├── venv/                        ← 虚拟环境（可删除重建）
│
├── backendAPI/gp/flaskback/
│   ├── backend_api/
│   │   ├── main.py              ← Flask 应用入口
│   │   └── .env                 ← 配置文件
│   └── webhook/
│       └── lambda_bot.py         ← 聊天机器人集成
│
└── KYC面板/gpstatus/            ← Flutter 前端（可选）
```

---

## ❌ 常见错误 & 解决方案

### 错误1: "ModuleNotFoundError: No module named 'flask'"
**原因**: 虚拟环境未激活

**解决**:
```powershell
# 激活虚拟环境
.\venv\Scripts\Activate.ps1

# 查看提示符，应该看到 (venv)
```

### 错误2: "Can't connect to MySQL server"
**原因**: 数据库未启动

**解决**:
```powershell
# 检查 Docker 容器
docker ps

# 如果没看到 'gp-mysql'，重新启动
docker run --name gp-mysql -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=gp_data -p 3306:3306 -d mysql:8.0

# 或本地 MySQL 检查
# Windows: 在任务管理器中搜索 MySQL 服务
# 或在"服务"中启动 MySQL80 服务
```

### 错误3: "OpenAIError: Incorrect API key provided"
**原因**: .env 文件中 API key 错误或缺失

**解决**:
```powershell
# 1. 从这里获取新的 key: https://platform.openai.com/api-keys
# 2. 编辑: backendAPI\gp\flaskback\backend_api\.env
# 3. 替换: OPENAI_API_KEY=sk-那是你的真实key
# 4. 重启 Flask 服务
```

### 错误4: "Port 5000 is already in use"
**原因**: 已有其他进程占用 5000 端口

**解决**:
```powershell
# 查看占用 5000 的进程
netstat -ano | findstr :5000

# 杀死进程 (XXXX 是 PID)
taskkill /PID XXXX /F

# 或改变 Flask 端口
python -m flask --app backend_api.main run --debug --port 5001
```

---

## 🔐 安全提示

⚠️ **重要**：这些文件包含敏感信息，**永远不要上传到 GitHub：**

- `.env` 文件（API keys、密码）
- `venv/` 目录（虚拟环境）

**添加到 .gitignore：**
```
venv/
*.env
__pycache__/
.DS_Store
*.pyc
```

---

## 📖 下一步学习

1. **理解项目结构**
   - 阅读 [README.txt](README.txt) 了解项目概览
   - 阅读 [LOCAL_DEPLOYMENT_GUIDE.md](LOCAL_DEPLOYMENT_GUIDE.md) 详细指南

2. **探索代码**
   - `backend_api/main.py` - Flask API 路由
   - `backend_api/compliance_tools.py` - KYC 验证逻辑
   - `webhook/lambda_bot.py` - 聊天机器人集成

3. **测试 API**
   ```powershell
   # 查看所有可用的 API endpoint
   curl http://localhost:5000/  # 根路由（如果有的话）
   ```

4. **连接 Chatwoot**
   - 已有测试环境: https://chatwootgp-c6fd041db72e.herokuapp.com
   - 测试账号: testaccount@gp.com / Aa223344!

---

## 💡 开发提示

### 虚拟环境编辑器集成
在 VS Code 中自动选择虚拟环境的 Python：

1. 打开命令面板 (Ctrl+Shift+P)
2. 搜索 "Python: Select Interpreter"
3. 选择 ".\venv\Scripts\python.exe"

### 自动重加载（热加载）
Flask 已配置 `--debug` 模式，修改 Python 文件后自动重启服务。

### 查看 API 文档
访问 API 文件了解可用的接口：
```powershell
# 在项目中搜索 @app.route
Select-String -Path "backendAPI\gp\flaskback\backend_api\*.py" -Pattern "@app.route"
```

---

**现在你已经准备好了！🎉 开始开发吧！**
