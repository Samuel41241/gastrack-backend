# 1. Base Image
FROM node:20-alpine

# 2. 🔑 PRISMA STABILITY: Install openssl (essential for Prisma 6+ on Alpine)
RUN apk add --no-cache openssl

WORKDIR /app

# 3. Dependencies
COPY package*.json ./
# We install all deps to ensure build tools (Nest CLI) are present
RUN npm install

# 4. Source Code
COPY . .

# 5. Production Environment
ENV NODE_ENV=production

# 6. Build Phase
# We generate the Prisma client (no URL needed at this exact moment)
RUN npx prisma generate
# We build the NestJS application
RUN npx @nestjs/cli build

# 7. Network
EXPOSE 3000

# 8. 🚀 STARTUP SHIELD
# We use 'sh -c' to ensure the environment variables are injected.
# We run migrations first, then start the server.
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]