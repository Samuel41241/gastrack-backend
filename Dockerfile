# 1. Use Node 20 Alpine for a small, secure production image
FROM node:20-alpine

# 2. 🔑 HARDENING: Install openssl (Required for Prisma 6+ on Alpine)
RUN apk add --no-cache openssl

WORKDIR /app

# 3. Install dependencies
# We install all deps first so we can run the build tools
COPY package*.json ./
RUN npm install

# 4. Copy application source
COPY . .

# 5. Set environment to production
ENV NODE_ENV=production

# 6. 🔑 PRODUCTION BUILD ARGUMENT
# Using your private URL ensures Prisma can validate correctly during build.
ARG DATABASE_URL="postgresql://postgres:wQfokqylyzskyXbOeQfqFguyaVncRLuP@postgres.railway.internal:5432/railway"
RUN npx prisma generate

# 7. Build the NestJS app using npx to guarantee the CLI is found
RUN npx @nestjs/cli build

# 8. Inform Railway of the port
EXPOSE 3000

# 9. 🚀 HARDENED STARTUP
# We force the export of DATABASE_URL to ensure Prisma CLI sees it immediately.
# Then we run migrations and start the server.
CMD ["sh", "-c", "export DATABASE_URL=$DATABASE_URL && npx prisma migrate deploy && node dist/main.js"]