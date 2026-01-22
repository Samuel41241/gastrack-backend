FROM node:20-alpine

# Set production environment
ENV NODE_ENV=production

WORKDIR /app

# Install dependencies first (better caching)
COPY package*.json ./
RUN npm install

# Copy application source
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# Build NestJS application
RUN npm run build

# Expose application port
EXPOSE 3000

# Start the application
CMD ["node", "dist/main.js"]
