FROM node:20-alpine

# Create app directory
WORKDIR /app

# Install OS deps needed for Prisma + Node
RUN apk add --no-cache libc6-compat openssl

# Copy dependency files first (better caching)
COPY package.json package-lock.json ./

# Install all dependencies (including dev for build)
RUN npm install

# Copy source code
COPY . .

# Generate Prisma Client (REQUIRED in container)
RUN npx prisma generate

# Build NestJS app
RUN npm run build

# Remove dev dependencies for production
RUN npm prune --omit=dev

# Railway exposes PORT dynamically
EXPOSE 3000

# Start app
CMD ["node", "dist/main.js"]
