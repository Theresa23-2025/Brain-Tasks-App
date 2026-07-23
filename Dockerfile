# Use a small, official Nginx base image
FROM nginx:alpine

# Remove the default Nginx HTML files to keep the image clean
RUN rm -rf /usr/share/nginx/html/*

# Copy the production build output into Nginx's HTML directory
COPY dist /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx in the foreground so the container keeps running
CMD ["nginx", "-g", "daemon off;"]
