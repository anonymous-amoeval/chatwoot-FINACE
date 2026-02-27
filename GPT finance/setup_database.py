"""
GPT Finance 数据库初始化脚本
运行此脚本以创建所需的数据库表

使用方式:
    python setup_database.py
"""

import os
import sys
import pymysql
from dotenv import load_dotenv

# 加载环境变量
load_dotenv(r"backendAPI\gp\flaskback\backend_api\.env")

def setup_database():
    """初始化数据库表"""
    
    # 获取数据库配置
    db_host = os.getenv("DB_HOST", "127.0.0.1")
    db_port = int(os.getenv("DB_PORT", "3306"))
    db_user = os.getenv("DB_USER", "gp_data")
    db_password = os.getenv("DB_PASSWORD", "jizbpLWSCSB5Jpyr")
    db_name = os.getenv("DB_NAME", "gp_data")
    
    print("=" * 60)
    print("GPT Finance 数据库初始化")
    print("=" * 60)
    print()
    print(f"📊 数据库连接信息:")
    print(f"   主机: {db_host}:{db_port}")
    print(f"   用户: {db_user}")
    print(f"   数据库: {db_name}")
    print()
    
    try:
        # 连接数据库
        print("🔗 正在连接数据库...")
        conn = pymysql.connect(
            host=db_host,
            port=db_port,
            user=db_user,
            password=db_password,
            database=db_name,
            charset='utf8mb4'
        )
        print("✅ 数据库连接成功！")
        
        cursor = conn.cursor()
        
        # 创建表定义
        tables = {
            "kyc_data": """
                CREATE TABLE IF NOT EXISTS kyc_data (
                    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
                    user_email VARCHAR(255) UNIQUE NOT NULL COMMENT '用户邮箱',
                    user_type VARCHAR(50) COMMENT '用户类型 (individual/company)',
                    
                    -- 个人证件认证
                    id_1 JSON COMMENT '证件一 (正面) 验证结果',
                    id_2 JSON COMMENT '证件二 (反面) 验证结果',
                    
                    -- 个人 KYC 检查
                    kyc_membercheck JSON COMMENT 'Member Check 验证结果',
                    kyc_google JSON COMMENT 'Google 搜索结果分析',
                    kyc_baidu JSON COMMENT '百度搜索结果分析',
                    kyc_tianyancha JSON COMMENT '天眼查检查结果 (个人)',
                    kyc_zgzxxxgkw JSON COMMENT '中国政府信息公开查询',
                    
                    -- 企业 KYC 检查
                    kyc_company_baidu JSON COMMENT '企业百度搜索结果分析',
                    kyc_company_google JSON COMMENT '企业 Google 搜索结果分析',
                    kyc_company_tianyancha JSON COMMENT '天眼查检查结果 (企业)',
                    kyc_company_abn_lookup JSON COMMENT 'ABN Lookup (澳洲企业登记)',
                    
                    -- 时间戳
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                    
                    INDEX idx_email (user_email),
                    INDEX idx_created_at (created_at)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KYC 认证数据表';
            """,
            
            "chat_messages": """
                CREATE TABLE IF NOT EXISTS chat_messages (
                    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
                    chatwoot_chat_id VARCHAR(255) COMMENT 'Chatwoot 聊天 ID',
                    thread_id VARCHAR(255) COMMENT 'OpenAI 线程 ID',
                    user_message TEXT COMMENT '用户消息',
                    bot_response TEXT COMMENT '机器人回复',
                    
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                    
                    INDEX idx_chat_id (chatwoot_chat_id),
                    INDEX idx_thread_id (thread_id),
                    INDEX idx_created_at (created_at)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天消息日志表';
            """,
            
            "users": """
                CREATE TABLE IF NOT EXISTS users (
                    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
                    email VARCHAR(255) UNIQUE NOT NULL COMMENT '用户邮箱',
                    user_type VARCHAR(50) COMMENT '用户类型 (individual/company)',
                    registration_status VARCHAR(50) DEFAULT 'pending' COMMENT '注册状态',
                    kyc_status VARCHAR(50) DEFAULT 'pending' COMMENT 'KYC 审核状态',
                    
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                    
                    INDEX idx_email (email),
                    INDEX idx_status (kyc_status)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';
            """,
            
            "orders": """
                CREATE TABLE IF NOT EXISTS orders (
                    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
                    user_email VARCHAR(255) NOT NULL COMMENT '用户邮箱',
                    order_id VARCHAR(255) UNIQUE NOT NULL COMMENT '订单编号',
                    from_currency VARCHAR(10) COMMENT '源币种',
                    to_currency VARCHAR(10) COMMENT '目标币种',
                    from_amount DECIMAL(15,2) COMMENT '源金额',
                    to_amount DECIMAL(15,2) COMMENT '目标金额',
                    exchange_rate DECIMAL(15,6) COMMENT '汇率',
                    order_status VARCHAR(50) DEFAULT 'pending' COMMENT '订单状态',
                    
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                    
                    INDEX idx_email (user_email),
                    INDEX idx_order_id (order_id),
                    INDEX idx_status (order_status),
                    INDEX idx_created_at (created_at)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';
            """
        }
        
        print()
        print("📋 创建数据库表...")
        print("-" * 60)
        
        for table_name, create_sql in tables.items():
            try:
                cursor.execute(create_sql)
                print(f"✅ 表 '{table_name}' 已创建/已存在")
            except Exception as e:
                print(f"⚠️  表 '{table_name}' 创建失败: {e}")
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print("-" * 60)
        print()
        print("=" * 60)
        print("✅ 数据库初始化完成！")
        print("=" * 60)
        print()
        print("📝 已创建的表:")
        for table_name in tables.keys():
            print(f"   • {table_name}")
        print()
        print("💡 接下来可以运行:")
        print("   python -m flask --app backend_api.main run --debug")
        print()
        
        return True
        
    except pymysql.Error as err:
        print()
        print("=" * 60)
        print("❌ 数据库连接错误!")
        print("=" * 60)
        print(f"错误信息: {err}")
        print()
        print("🔍 排查步骤:")
        print("1. 确保 MySQL 服务器已启动")
        print("   - Windows: 检查任务管理器或 MySQL Workbench")
        print("   - Docker: docker ps | grep mysql")
        print()
        print("2. 确认数据库凭证正确")
        print(f"   主机: {db_host}:{db_port}")
        print(f"   用户: {db_user}")
        print(f"   密码: {'*' * len(db_password)}")
        print()
        print("3. 确保数据库存在")
        print("   mysql -u root -p")
        print("   CREATE DATABASE gp_data;")
        print()
        return False

if __name__ == "__main__":
    success = setup_database()
    sys.exit(0 if success else 1)
