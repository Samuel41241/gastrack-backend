FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# Build app
RUN npm run build

# Remove dev dependencies
RUN npm prune --omit=dev

EXPOSE 3000

CMD ["node", "dist/main.js"]
