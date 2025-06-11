# Stage 1: Build
FROM bitnami/node:9 AS builder
ENV NODE_ENV=production

# Copy app's source code to the /app directory
COPY . /app
WORKDIR /app

# Install Node.js dependencies
RUN npm install

# Stage 2: Production Image
FROM bitnami/node:9-prod AS runtime
ENV NODE_ENV=production
WORKDIR /app

COPY --from=builder /app /app

ENV PORT=5000
EXPOSE 5000

# Start the application
CMD ["npm", "start"]
