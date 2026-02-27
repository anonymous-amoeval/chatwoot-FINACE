@echo off
REM 此脚本自动设置 GPT Finance 本地开发环境

echo.
echo ========================================
echo  GPT Finance 本地开发环境设置脚本
echo ========================================
echo.

REM 第1步：检查 Python
echo [1/5] 检查 Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python未安装！ 请从 https://python.org 下载安装
    pause
    exit /b 1
)
echo ✅ Python 已安装

REM 第2步：创建虚拟环境
echo.
echo [2/5] 创建虚拟环境...
if exist venv (
    echo ℹ️  虚拟环境已存在，跳过创建
) else (
    python -m venv venv
    echo ✅ 虚拟环境创建成功
)

REM 第3步：激活虚拟环境
echo.
echo [3/5] 激活虚拟环境...
call venv\Scripts\activate.bat
echo ✅ 虚拟环境已激活

REM 第4步：安装依赖
echo.
echo [4/5] 安装 Python 依赖包...
pip install --upgrade pip >nul 2>&1
pip install flask flask-cors pymysql requests beautifulsoup4 googlesearch-python openai python-dotenv langchain
echo ✅ 依赖包安装完成

REM 第5步：创建 .env 示例文件
echo.
echo [5/5] 创建环境配置文件...
if not exist backendAPI\gp\flaskback\backend_api\.env (
    (
        echo # OpenAI API 配置
        echo OPENAI_API_KEY=sk-your-actual-key-here
        echo.
        echo # 数据库配置
        echo DB_HOST=127.0.0.1
        echo DB_PORT=3306
        echo DB_USER=gp_data
        echo DB_PASSWORD=jizbpLWSCSB5Jpyr
        echo DB_NAME=gp_data
        echo.
        echo # Chatwoot 配置
        echo CHATWOOT_URL=https://chatwootgp-c6fd041db72e.herokuapp.com
        echo CHATWOOT_BOT_TOKEN=BxjuXQJ4PTkPuUsMctrcKTBc
        echo CHATWOOT_API_TOKEN=Yc69AgDCiYwpQr4Zun4tQrDv
        echo CHATWOOT_ACCOUNT_ID=1
        echo.
        echo # OpenAI Assistant
        echo ASSISTANT_ID=asst_VEDt30cOoG7hHJEDEvAsHHjW
    ) > backendAPI\gp\flaskback\backend_api\.env
    echo ✅ .env 文件已创建
    echo ℹ️  请修改 .env 文件中的 OPENAI_API_KEY
) else (
    echo ℹ️  .env 文件已存在，跳过创建
)

echo.
echo ========================================
echo  设置完成！✅
echo ========================================
echo.
echo 下一步：
echo 1. 修改 .env 文件添加你的 OpenAI API key
echo 2. 运行数据库初始化脚本（如需要）
echo 3. 启动 Flask 服务器
echo.
echo 启动 Flask 命令：
echo   cd backendAPI\gp\flaskback
echo   python -m flask --app backend_api.main run --debug
echo.
pause
