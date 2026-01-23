FROM node:20-alpine

# 🛡️ Standard: Prisma 6+ REQUIRES openssl on Alpine Linux
RUN apk add --no-cache openssl

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

ENV NODE_ENV=production

# 🛡️ Standard: Generate client at build, Migrate at runtime
RUN npx prisma generate
RUN npx @nestjs/cli build

EXPOSE 3000

# 🛡️ Standard: Use shell to ensure environment variable mapping
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]