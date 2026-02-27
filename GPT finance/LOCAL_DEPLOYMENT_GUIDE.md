# 🚀 GPT Finance 本地PC快速部署指南

## 什么是这个项目？
这是一个金融服务聊天系统，包含：
- **后端 API**：处理数据库、OpenAI集成、合规检查
- **聊天系统**：Chatwoot（开源通讯平台）
- **前端**：Flutter应用（KYC面板）

## 📦 本地部署策略（推荐：虚拟环境）

由于这里有多个Python依赖，我们使用**虚拟环境**（Virtual Environment）来隔离，避免污染主系统的Python。

### 什么是虚拟环境？
虚拟环境就像一个「独立的Python沙箱」，在这个沙箱里安装的包不会影响你电脑其他项目，删除沙箱就完全卸载了。

---

## ✅ 第一步：安装依赖工具（5分钟）

### 1.1 安装 MySQL（本地数据库）
**选项A：快速方式 - 使用 Docker**
```powershell
# 安装 Docker Desktop (如还未安装)
# 下载: https://www.docker.com/products/docker-desktop

# 启动 MySQL 容器 (开箱即用)
docker run --name gp-mysql -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=gp_data -p 3306:3306 -d mysql:8.0
```

**选项B：本地安装 MySQL**
- 下载: https://dev.mysql.com/downloads/mysql/
- 记住安装时设置的 root 密码

### 1.2 验证 MySQL 连接
```powershell
# 进入 MySQL 命令行
mysql -h 127.0.0.1 -u root -p
# 输入密码（如果用 Docker 就是: root123）

# 在 MySQL 中执行
CREATE DATABASE gp_data;
CREATE USER 'gp_data'@'localhost' IDENTIFIED BY 'jizbpLWSCSB5Jpyr';
GRANT ALL PRIVILEGES ON gp_data.* TO 'gp_data'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

## ⚙️ 第二步：创建虚拟环境（3分钟）

```powershell
# 进入项目根目录
cd "C:\Users\92312\Downloads\GPT finance\GPT finance"

# 创建虚拟环境（名字叫 venv）
python -m venv venv

# 激活虚拟环境
# ✅ Windows PowerShell:
.\venv\Scripts\Activate.ps1

# 如果出现权限错误，执行:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 成功后你会看到 (venv) 前缀
```

**验证虚拟环境已激活：**
```powershell
# 应该显示虚拟环境内的 Python 路径
python -c "import sys; print(sys.executable)"
# 输出应该包含 \venv\
```

---

## 📥 第三步：安装 Python 依赖包（5-10分钟）

```powershell
# 确保虚拟环境已激活（看到 (venv) 前缀）

# 升级 pip（包管理器）
python -m pip install --upgrade pip

# 安装后端 API 所需的包
pip install flask flask-cors pymysql requests beautifulsoup4 googlesearch-python openai python-dotenv langchain google-search-results

# 验证安装成功
pip list
```

**如果某个包安装失败？**
- 尝试: `pip install --upgrade setuptools wheel`
- 然后重新安装

---

## 🔐 第四步：配置环境变量（5分钟）

### 创建 `.env` 文件在后端目录

在 `backendAPI\gp\flaskback\backend_api\` 目录下创建 `.env` 文件：

**文件路径**: `backendAPI\gp\flaskback\backend_api\.env`

**内容**:
```env
# OpenAI API 配置（需要你自己的 OpenAI API key）
OPENAI_API_KEY=sk-your-actual-key-here

# 数据库配置
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=gp_data
DB_PASSWORD=jizbpLWSCSB5Jpyr
DB_NAME=gp_data

# Chatwoot 配置（如果要测试聊天功能）
CHATWOOT_URL=https://chatwootgp-c6fd041db72e.herokuapp.com
CHATWOOT_BOT_TOKEN=BxjuXQJ4PTkPuUsMctrcKTBc
CHATWOOT_API_TOKEN=Yc69AgDCiYwpQr4Zun4tQrDv
CHATWOOT_ACCOUNT_ID=1

# OpenAI Assistant
ASSISTANT_ID=asst_VEDt30cOoG7hHJEDEvAsHHjW
```

**警告⚠️**: 
- `.env` 文件包含敏感信息，**永远不要上传到 Git**
- 如果没有自己的 OpenAI API key，可以暂时跳过，后面会说明如何获取

---

## 🐛 第五步：修复代码中的硬编码凭证（10分钟）

项目代码中有一些硬编码的凭证需要修改成使用环境变量。

### 5.1 修复 `lambda_bot.py`

**文件路径**: `backendAPI\gp\flaskback\webhook\lambda_bot.py`

**目前的问题**: 第14行有硬编码的 OpenAI API key

**修复方法**:
1. 在文件顶部添加:
```python
import os
from dotenv import load_dotenv

load_dotenv()

# 替换第14行硬编码的 API key
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
chatwoot_url = os.getenv("CHATWOOT_URL", "https://chatwootgp-c6fd041db72e.herokuapp.com")
chatwoot_bot_token = os.getenv("CHATWOOT_BOT_TOKEN", "BxjuXQJ4PTkPuUsMctrcKTBc")
# ... 其他变量也改成 os.getenv()
```

### 5.2 修复 `main.py` (backend_api)

**文件路径**: `backendAPI\gp\flaskback\backend_api\main.py`

**修复第12-15行的硬编码数据库凭证**:
```python
import os
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    try:
        conn = pymysql.connect(
            host=os.getenv("DB_HOST", "127.0.0.1"),
            user=os.getenv("DB_USER", "gp_data"),
            password=os.getenv("DB_PASSWORD", "jizbpLWSCSB5Jpyr"),
            database=os.getenv("DB_NAME", "gp_data"),
            cursorclass=pymysql.cursors.DictCursor
        )
        return conn
    except pymysql.Error as err:
        print(f"Error: {err}")
        return None
```

---

## 🚀 第六步：运行后端 API（第一次测试！）

```powershell
# 确保虚拟环境激活 (看到 (venv) 前缀)
# 进入后端目录
cd backendAPI\gp\flaskback

# 运行 Flask 开发服务器
python -m flask --app backend_api.main run --debug

# 你应该看到:
# * Running on http://127.0.0.1:5000
# * Debug mode: on
```

**测试 API 是否工作**:

打开另一个 PowerShell 窗口（不要关闭运行的 Flask）：
```powershell
# 测试 API endpoint
curl -X GET http://localhost:5000/getallkycstatus

# 如果数据库连接成功，应该返回 JSON 数据
# 如果失败，会显示错误信息
```

---

## 🗄️ 第七步：初始化数据库表（可选但推荐）

如果你想完整测试，需要创建数据库表。创建 `setup_database.py`：

```powershell
# 在项目根路径创建这个文件
cd "C:\Users\92312\Downloads\GPT finance\GPT finance"
```

**创建文件**: `setup_database.py`
```python
import os
import pymysql
from dotenv import load_dotenv

load_dotenv()

# 连接数据库
conn = pymysql.connect(
    host=os.getenv("DB_HOST", "127.0.0.1"),
    user=os.getenv("DB_USER", "gp_data"),
    password=os.getenv("DB_PASSWORD", "jizbpLWSCSB5Jpyr"),
    database=os.getenv("DB_NAME", "gp_data"),
)

cursor = conn.cursor()

# 创建 KYC 数据表
sql = """
CREATE TABLE IF NOT EXISTS kyc_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(255) UNIQUE NOT NULL,
    user_type VARCHAR(50),
    id_1 JSON,
    id_2 JSON,
    kyc_membercheck JSON,
    kyc_google JSON,
    kyc_baidu JSON,
    kyc_tianyancha JSON,
    kyc_zgzxxxgkw JSON,
    kyc_company_baidu JSON,
    kyc_company_google JSON,
    kyc_company_tianyancha JSON,
    kyc_company_abn_lookup JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
"""

cursor.execute(sql)
conn.commit()
print("✅ 数据库表创建成功！")

cursor.close()
conn.close()
```

运行初始化脚本：
```powershell
python setup_database.py
```

---

## 🎯 快速检查清单

| 步骤 | 命令/验证 | 预期结果 |
|------|---------|--------|
| 1️⃣ Python | `python --version` | 3.7+ |
| 2️⃣ MySQL | `mysql -u root -p` | 连接成功 |
| 3️⃣ 虚拟环境 | `python -c "import sys; print(sys.executable)"` | 路径包含 `\venv\` |
| 4️⃣ 依赖包 | `pip list \| grep flask` | flask 已安装 |
| 5️⃣ 环境变量 | `.env` 文件存在 | 文件在正确位置 |
| 6️⃣ API 启动 | `python -m flask --app backend_api.main run` | 显示 `Running on http://127.0.0.1:5000` |
| 7️⃣ 测试连接 | `curl http://localhost:5000/getallkycstatus` | 返回 JSON 或错误信息 |

---

## 🛑 常见问题排查

### 问题1：ModuleNotFoundError: No module named 'flask'
**解决**: 虚拟环境没激活
```powershell
# 重新激活虚拟环境
.\venv\Scripts\Activate.ps1
# 然后重新安装: pip install flask
```

### 问题2：CORS 错误（跨域请求被拒）
**解决**: API 已配置 CORS，但可能需要刷新浏览器缓存

### 问题3：数据库连接失败
```powershell
# 检查 MySQL 是否运行
mysql -u root -p
# 如果无法连接，检查:
# 1. MySQL 是否启动
# 2. 用户名/密码是否正确
# 3. 数据库是否存在
```

### 问题4：OpenAI API 错误
```
需要你自己的 OpenAI API key:
1. 访问: https://platform.openai.com/api-keys
2. 创建新 API key
3. 复制到 .env 文件中的 OPENAI_API_KEY
```

---

## 📁 本地部署后的目录结构

```
GPT finance/
├── venv/                          # ← 虚拟环境（可以删除重建）
├── .env                           # ← 你的环保变量文件（不要提交）
├── setup_database.py              # ← 初始化数据库脚本
├── backendAPI/
│   └── gp/
│       └── flaskback/
│           ├── backend_api/
│           │   ├── main.py        # ← Flask API 主文件
│           │   └── .env           # ← 或放在这里
│           └── webhook/
│               └── lambda_bot.py   # ← 聊天机器人集成
└── KYC面板/
    └── gpstatus/                  # ← Flutter 前端（本地可不部署）
```

---

## 🎓 后续步骤

### 既然后端能运行了，接下来可以：

1. **测试更多 API endpoints**
   ```powershell
   # 列出所有可用 API
   grep -r "@app.route" backendAPI/gp/flaskback/
   ```

2. **探索数据模型**
   - 查看 `compliance_tools.py` 了解 KYC 流程
   - 查看 `common_tools.py` 了解通用工具

3. **集成 Chatwoot**（可选）
   - 与已有的 Chatwoot 实例连接
   - 测试聊天机器人集成

4. **构建 Flutter 前端**
   ```powershell
   # 如果要测试 Flutter，需要单独安装 Flutter SDK
   # 但这对测试后端不是必需的
   ```

---

## ✨ 完全卸载（如果有问题需要重新开始）

```powershell
# 停用虚拟环境
deactivate

# 删除虚拟环境（会释放磁盘空间）
Remove-Item -Recurse -Force venv

# 重新开始时，从「第二步」再来一次就行
```

---

**恭喜！🎉 你现在可以在本地开发和测试 GPT Finance 了！**

任何问题，参考「常见问题排查」部分。
