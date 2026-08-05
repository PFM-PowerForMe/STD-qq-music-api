FROM docker.io/library/node:22-alpine AS builder

WORKDIR /app

COPY source-src/ .

RUN npm install -g npm@11

RUN npm install --registry=https://registry.npmmirror.com

RUN npm run build

RUN npm prune --production


FROM docker.io/library/node:22-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production


COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE 3200

ENTRYPOINT ["npm", "run"]
CMD ["start"]