# 1. Use Node 20 Alpine for production
FROM node:20-alpine

# 2. Install openssl - Required for Prisma on Alpine
RUN apk add --no-cache openssl

WORKDIR /app

# 3. Copy package files
COPY package*.json ./

# 4. Install ALL dependencies (including devDependencies) 
# We need them for the build step. We set NODE_ENV=production AFTER this.
RUN npm install

# 5. Copy your application source
COPY . .

# 6. Set Environment to production for the build and runtime
ENV NODE_ENV=production

# 7. 🔑 Build Argument for Prisma
# Using your private URL helps Prisma validate the schema during build.
ARG DATABASE_URL="postgresql://postgres:wQfokqylyzskyXbOeQfqFguyaVncRLuP@postgres.railway.internal:5432/railway"
RUN npx prisma generate

# 8. 🔑 FIX: Run the build using npx to ensure Nest CLI is found
RUN npx @nestjs/cli build

# 9. Inform Docker the app runs on port 3000
EXPOSE 3000

# 10. 🚀 PRODUCTION STARTUP
# We run migrations first to ensure the DB is ready, then start the compiled JS.
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]