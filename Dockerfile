# --- 第一阶段：构建 ---
FROM rust:1.75-slim AS builder

# 安装 mdbook
RUN cargo install mdbook

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 执行构建，生成输出目录通常为 /app/book
RUN mdbook build

# --- 第二阶段：提供服务 ---
FROM nginx:alpine

# 将构建好的静态文件复制到 Nginx 默认目录
COPY --from=builder /app/book /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
