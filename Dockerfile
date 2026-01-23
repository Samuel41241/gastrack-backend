# 1. Use the stable Node.js 20 Alpine image for a small footprint
FROM node:20-alpine

# 2. Set environment to production
ENV NODE_ENV=production

WORKDIR /app

# 3. Copy package files first to leverage Docker layer caching
COPY package*.json ./

# 4. Install production dependencies
RUN npm install

# 5. Copy your source code (including the prisma folder)
COPY . .

# 6. 🔑 PRODUCTION BUILD ARGUMENT
# We use your private URL so Prisma can generate the client correctly.
# This does not "hardcode" it into the final running app; Railway overrides it at runtime.
ARG DATABASE_URL="postgresql://postgres:wQfokqylyzskyXbOeQfqFguyaVncRLuP@postgres.railway.internal:5432/railway"
RUN npx prisma generate

# 7. Build the NestJS application
RUN npm run build

# 8. Inform Docker that the app listens on port 3000
EXPOSE 3000

# 9. 🚀 PRODUCTION STARTUP COMMAND
# We use 'sh -c' to run migrations BEFORE starting the server.
# This ensures your tables exist and match your schema before the app tries to use them.
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]