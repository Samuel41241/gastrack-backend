FROM node:20-alpine

# Set production environment
ENV NODE_ENV=production

WORKDIR /app

# Install dependencies
COPY package*.json ./
# Note: We use --omit=dev only if Nest CLI is in 'dependencies'
RUN npm install

# Copy application source
COPY . .

# 🔑 FIX: Provide a placeholder for the build phase
# This prevents the "DATABASE_URL not found" error during 'prisma generate'
ENV DATABASE_URL="postgresql://placeholder:placeholder@localhost:5432/placeholder"

# Generate Prisma Client
RUN npx prisma generate

# Build NestJS application
RUN npm run build

# Expose application port
EXPOSE 3000

# 🚀 FINAL FIX: Run migrations BEFORE starting the app
# Using 'sh -c' allows us to chain commands at runtime
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]