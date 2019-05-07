FROM docker.io/library/node:22-alpine AS builder

# Create app directory
WORKDIR /app

COPY source-src/web/package.json .

RUN npm install --registry=https://registry.npmmirror.com

COPY source-src/ .

RUN npm run build


FROM docker.io/library/node:22-alpine AS runtime

WORKDIR /app

# 设置生产环境变量
ENV NODE_ENV=production

# 从 builder 阶段仅复制构建产物和运行依赖
# (注：根据具体项目的产物目录结构调整，例如 dist 或 .next 等)
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# 暴露服务端口
EXPOSE 3200

# 推荐使用 CMD 执行产物或启动脚本
ENTRYPOINT ["npm", "run"]
CMD ["start"]