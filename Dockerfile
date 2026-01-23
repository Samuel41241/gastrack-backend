# 1. Use Node 20 Alpine (standard production base)
FROM node:20-alpine

# 2. Install openssl - Prisma 6+ REQUIRES this on Alpine to talk to Postgres
RUN apk add --no-cache openssl

# 3. Set environment to production
ENV NODE_ENV=production

WORKDIR /app

# 4. Install dependencies (Prisma must be in 'dependencies', not 'devDependencies')
COPY package*.json ./
RUN npm install

# 5. Copy your code
COPY . .

# 6. 🔑 PRODUCTION BUILD STEP
# We skip strict validation during build to avoid 'localhost' errors.
# The client is generated here, but it will use the REAL URL at runtime.
RUN npx prisma generate

# 7. Build the NestJS app
RUN npm run build

# 8. Expose port (Railway will override this with its own PORT variable)
EXPOSE 3000

# 9. 🚀 THE PRODUCTION STARTUP SEQUENCE
# We use 'sh -c' to ensure Railway's variables are fully injected into the shell.
# We run migrations first, then start the server.
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]