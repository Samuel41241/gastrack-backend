FROM node:20-alpine

# Create app directory
WORKDIR /app

# Install OS deps needed for Prisma + Node
RUN apk add --no-cache libc6-compat openssl

# Copy dependency files first (better caching)
COPY package.json package-lock.json ./

# Install dependencies (needed for build)
RUN npm install

# Copy source code
COPY . .

# Build NestJS app
RUN npm run build

# Remove dev dependencies for production
RUN npm prune --omit=dev

# Railway exposes PORT dynamically
EXPOSE 3000

# Prisma runs ONLY at runtime (env vars available)
CMD sh -c "npx prisma migrate deploy && node dist/main.js"
