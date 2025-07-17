# Use Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy rest of the application files
COPY . .

# Expose application port (update if needed)
EXPOSE 3000

# Define the command to run your app
CMD [ "node", "index.js" ]
