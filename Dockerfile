
# ---- Base Node ----
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# ---- Dependencies ----
FROM base AS dependencies
RUN npm ci --only=production

# For development dependencies
FROM dependencies AS dev-dependencies
RUN npm ci

# ---- Build ----
FROM dev-dependencies AS build
COPY . .
RUN npm run build

# ---- Production ----
FROM node:18-alpine AS production
WORKDIR /app
# Copy production dependencies only
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package*.json ./
COPY --from=build /app/next.config.js ./next.config.js
COPY --from=build /app/next-i18next.config.js ./next-i18next.config.js

# Add metadata
LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="1.0"
LABEL description="Next.js Chatbot Application"

# Set environment variables
ENV NODE_ENV production

# Expose the port the app will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
